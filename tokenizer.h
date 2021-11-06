#ifndef TOKENIZER_H
#define TOKENIZER_H

#include <QString>

class Tokenizer final
{
public:
    struct token final {
        enum TokenType {
            ttEOF,
            ttWord,
            ttOther
        };
        TokenType type;
        QString str;
    };

    Tokenizer(QString str) : offset_{0}, str_{str} {}

    token next_token() {
        if (offset_ == str_.size())
            return { token::ttEOF, {} };
        if (str_.at(offset_).isLetter())
            return next_token_impl<token::ttWord>([](const QChar& ch){ return !ch.isLetter(); });
        else
            return next_token_impl<token::ttOther>([](const QChar& ch){ return ch.isLetter(); });
    }
private:
    template<token::TokenType Ty, typename Func>
    token next_token_impl(Func is_a){
        const auto offset = offset_;
        const auto end_it = std::find_if(str_.begin() + offset, str_.end(), is_a);
        offset_ = std::distance(str_.begin(), end_it);
        return { Ty, str_.mid(offset, offset_ - offset) };
    }

    int offset_;
    QString str_;
};

#endif // TOKENIZER_H
