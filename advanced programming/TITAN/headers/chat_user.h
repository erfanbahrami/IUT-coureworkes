#ifndef CHAT_USER_H
#define CHAT_USER_H

#include <QWidget>
#include "secondary_thread.h"
#include <QDialog>
#include <QJsonDocument>
#include <QJsonObject>
#include <QDir>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QWidget>
#include <iostream>
#include <QFile>
#include <QString>

namespace Ui {
class chat_user;
}

class chat_user : public QWidget
{
    Q_OBJECT

public:
    QString sended_username;
    void setName(QString);

    explicit chat_user(QWidget *parent = 0);
    ~chat_user();

    secondary_thread * t_user;

    void replyfinished10(QNetworkReply * reply);

    bool cc();

private:
    Ui::chat_user *ui;

public slots:
     void userSlut();
};

#endif // CHAT_USER_H
