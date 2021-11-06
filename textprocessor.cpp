#include "textprocessor.h"

#include <QDebug>

#include "tokenizer.h"

TextProcessor::TextProcessor(QObject* parent)
    : QObject{parent}
{ }

QVector<QString> TextProcessor::translate(Database* db, const QString& text, Database::Direction dir)
{
    QVector<QString> result;

    Tokenizer tokenizer(text);
    for(Tokenizer::token tkn = tokenizer.next_token(); ; tkn = tokenizer.next_token()) {

        if (tkn.type == Tokenizer::token::ttEOF) {
            break;
        }
        else if (tkn.type == Tokenizer::token::ttWord) {
            auto translations = db->fetchTranslations(tkn.str.toLower(), dir);

            if (!translations.isEmpty()) {
                if (withCapitalLetter(tkn.str)) {
                    toCapitalLetter(translations.first());
                }
                if (tkn.str.isUpper()) {
                    translations.first() = translations.first().toUpper();
                }

                if (result.isEmpty()) {
                    result = translations;
                }
                else if (result.size() > 1) {
                    result.erase(result.begin() + 1, result.end());
                    result.first() += translations.first();
                }
                else {
                    result.first() += translations.first();
                }
                continue;
            }
        }

        if (result.isEmpty()) {
            result.append(tkn.str);
        }
        else if (result.size() > 1) {
            result.erase(result.begin() + 1, result.end());
            result.first() += tkn.str;
        }
        else {
            result.first() += tkn.str;
        }
    }

    return result;
}

bool TextProcessor::withCapitalLetter(const QString& text) const noexcept
{
    return text.isEmpty() ? false : text.front().isUpper();
}

void TextProcessor::toCapitalLetter(QString& text) noexcept
{
    if (!text.isEmpty())
        text.replace(0, 1, text.front().toUpper());
}
