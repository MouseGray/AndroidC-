#ifndef TRANSLATOR_H
#define TRANSLATOR_H

#include <QPair>
#include <QObject>
#include <QString>
#include <QVariant>
#include <QSqlDatabase>

class Database : public QObject
{
    Q_OBJECT
public:
    enum Direction : bool {
        RussianToEnglish,
        EnglishToRussian
    };
    Q_ENUM(Direction)
public:
    static constexpr auto DATABASE_NAME = "TranslatorDB.db";
public:
    explicit Database(QObject *parent = nullptr);

    Q_INVOKABLE bool
    open();

    Q_INVOKABLE void
    close();

    Q_INVOKABLE bool
    initializeTable();

    Q_INVOKABLE QVector<QString>
    fetchWordPairs(const QString& letters, Direction dir);

    Q_INVOKABLE QVector<QString>
    fetchTranslations(const QString& word, Direction dir);

    Q_INVOKABLE void
    clearBestTranslation(const QString& word, Direction dir);

    Q_INVOKABLE void
    setBestTranslation(const QString& word_from, const QString& word_to, Direction dir);

    Q_INVOKABLE void
    addTranslation(const QString& word_from, const QString& word_to, Direction dir);

    Q_INVOKABLE Direction
    invertDirection(Direction dir) const;
signals:
    void runtimeError(QString error);
private:
    inline static QString
    postfix_to_(Direction dir) {
        return dir == Direction::RussianToEnglish ?
                    "en" : "ru";
    }

    inline static QString
    postfix_from_(Direction dir) {
        return dir == Direction::RussianToEnglish ?
                    "ru" : "en";
    }

    QSqlDatabase db_;
};

Q_DECLARE_METATYPE(Database::Direction)

#endif // TRANSLATOR_H
