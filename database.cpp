#include "database.h"

#include <QSqlQuery>
#include <QSqlError>
#include <QFile>
#include <QStandardPaths>
#include <QDebug>
#include <QSqlDriver>

Database::Database(QObject* parent)
    : QObject{parent}, db_{QSqlDatabase::addDatabase("QSQLITE")}
{
#ifdef ANDROID
    QFile db_file{QString{"assets:/"} + DATABASE_NAME};

    QString writable_location = QStandardPaths::writableLocation(QStandardPaths::StandardLocation::AppDataLocation);
    db_file.copy(writable_location + "/" + DATABASE_NAME);

    QFile::setPermissions(writable_location + "/" + DATABASE_NAME, QFile::WriteOwner | QFile::ReadOwner);
#endif
    db_.setDatabaseName(DATABASE_NAME);
}

bool Database::open()
{
    if (!db_.isOpen())
    {
        return db_.open();
    }
    return true;
}

void Database::close()
{
    db_.close();
}

bool Database::initializeTable()
{
    QSqlQuery query{QString{
            "CREATE TABLE IF NOT EXISTS \"EnglishRussian\" (         "
            "    id      INTEGER          PRIMARY KEY AUTOINCREMENT, "
            "    word_ru VARCHAR (0, 120) NOT NULL,                  "
            "    word_en VARCHAR (0, 120) NOT NULL,                  "
            "    best_ru BOOLEAN,                                    "
            "    best_en BOOLEAN                                     "
            ")                                                       "
        }, db_};

    if (!query.exec()) {
        runtimeError("SQL error: " + query.lastError().text());
        return false;
    }

    return true;
}

QVector<QString> Database::fetchWordPairs(const QString& letters, Direction dir)
{
    QSqlQuery query{QString{
            "SELECT                 "
            "    word_%1,           "
            "    word_%2            "
            "FROM                   "
            "    \"EnglishRussian\" "
            "WHERE                  "
            "    word_%1 LIKE '%3%' "
            "    AND                "
            "    best_%2 = true     "
        }
                .arg(Database::postfix_from_(dir))
                .arg(Database::postfix_to_(dir))
                .arg(letters), db_};

    if (!query.exec()) {
        runtimeError("SQL error: " + query.lastError().text());
        return {};
    }

    QVector<QString> result;
    while (query.next()) {
        result.push_back(query.value(0).toString() + ' ' +
                         query.value(1).toString());
    }

    return result;
}

QVector<QString> Database::fetchTranslations(const QString& word, Direction dir)
{
    QSqlQuery query{db_};
    query.prepare(QString{
                      "SELECT                 "
                      "    word_%1,           "
                      "    best_%1            "
                      "FROM                   "
                      "    \"EnglishRussian\" "
                      "WHERE                  "
                      "    word_%2 = :word    "
                      "ORDER BY 2 desc, 1     "
                  }
                  .arg(Database::postfix_to_(dir))
                  .arg(Database::postfix_from_(dir)));
    query.bindValue(":word", word);

    if (!query.exec()) {
        runtimeError("SQL error: " + query.lastError().text());
        return {};
    }

    QVector<QString> result;
    while (query.next()) {
        result.push_back(query.value(0).toString());
    }

    return result;
}

void Database::clearBestTranslation(const QString& word, Direction dir)
{
    QSqlQuery query{db_};
    query.prepare(QString{
                      "UPDATE                 "
                      "    \"EnglishRussian\" "
                      "SET                    "
                      "    best_%1 = false    "
                      "WHERE                  "
                      "    word_%2 = :word    "
                  }
                  .arg(Database::postfix_to_(dir))
                  .arg(Database::postfix_from_(dir)));
    query.bindValue(":word", word);

    if (!query.exec()) {
        runtimeError("SQL error: " + query.lastError().text());
    }
}

void Database::setBestTranslation(const QString& word_from, const QString& word_to, Direction dir)
{
    qDebug() << word_from << word_to;
    QSqlQuery query{db_};
    query.prepare(QString{
                      "UPDATE                   "
                      "    \"EnglishRussian\"   "
                      "SET                      "
                      "    best_%1 = true       "
                      "WHERE                    "
                      "    word_%1 = :word_to   "
                      "    AND                  "
                      "    word_%2 = :word_from "
                  }
                  .arg(Database::postfix_to_(dir))
                  .arg(Database::postfix_from_(dir)));
    query.bindValue(":word_to", word_to);
    query.bindValue(":word_from", word_from);

    if (!query.exec()) {
        runtimeError("SQL error: " + query.lastError().text());
    }
}

void Database::addTranslation(const QString& word_from, const QString& word_to, Direction dir)
{
    QSqlQuery query{db_};
    query.prepare(QString{
                      "INSERT INTO              "
                      "    \"EnglishRussian\"(  "
                      "        word_%1,         "
                      "        word_%2,         "
                      "        best_%1,         "
                      "        best_%2          "
                      "    )                    "
                      "VALUES(                  "
                      "    :word_to,            "
                      "    :word_from,          "
                      "    true,                "
                      "    true                 "
                      ")                        "
                  }
                  .arg(Database::postfix_to_(dir))
                  .arg(Database::postfix_from_(dir)));
    query.bindValue(":word_to", word_to);
    query.bindValue(":word_from", word_from);

    if (!query.exec()) {
        runtimeError("SQL error: " + query.lastError().text());
    }
}

Database::Direction Database::invertDirection(Direction dir) const
{
    return dir == Direction::EnglishToRussian ?
                Direction::RussianToEnglish :
                Direction::EnglishToRussian;
}
