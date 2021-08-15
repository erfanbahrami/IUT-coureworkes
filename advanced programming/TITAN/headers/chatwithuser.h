#ifndef CHATWITHUSER_H
#define CHATWITHUSER_H

#include <QWidget>
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
#include "secondary_thread.h"

namespace Ui {
class chatWithUser;
}

class chatWithUser : public QWidget
{
    Q_OBJECT

public:
    QString sended_username;
    void setName(QString);

    explicit chatWithUser(QWidget *parent = 0);
    ~chatWithUser();

    secondary_thread * t_user;

    void replyfinished10(QNetworkReply * reply);
    void replyfinished12(QNetworkReply * reply);

    bool cc();
private:
    Ui::chatWithUser *ui;
public slots:
    void userSlut();
private slots:
    void on_pushButton_clicked();
    void on_back_clicked();
};

#endif // CHATWITHUSER_H
