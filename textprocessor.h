#ifndef TEXTPROCESSOR_H
#define TEXTPROCESSOR_H

#include <QObject>

#include <algorithm>

#include "database.h"

class TextProcessor : public QObject
{
    Q_OBJECT
public:
    explicit TextProcessor(QObject *parent = nullptr);

    Q_INVOKABLE QVector<QString> translate(Database* db, const QString& text, Database::Direction dir);
private:
    bool withCapitalLetter(const QString& text) const noexcept;
    void toCapitalLetter(QString& text) noexcept;

};

#endif // TEXTPROCESSOR_H
