#ifndef CHAT2_H
#define CHAT2_H

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
class chat2;
}

class chat2 : public QWidget
{
    Q_OBJECT

public:
    QString sended_username;
    void setName(QString);

    explicit chat2(QWidget *parent = 0);
    ~chat2();

    secondary_thread * t_user;

    void replyfinished10(QNetworkReply * reply);
    void replyfinished12(QNetworkReply * reply);

    bool cc();


private:
    Ui::chat2 *ui;

public slots:
    void userSlut();
private slots:
    void on_pushButton_clicked();
};

#endif // CHAT2_H
