#ifndef CHAT_H
#define CHAT_H

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
class chat;
}

class chat : public QWidget
{
    Q_OBJECT

public:    
    explicit chat(QWidget *parent = 0);
    ~chat();

    QString sended_username;
    void setName(QString);

    void chapOffline();

    secondary_thread * t_group;

    void replyfinished9(QNetworkReply * reply);
    void replyfinished11(QNetworkReply * reply);

    bool cc();

private:
    Ui::chat *ui;

public slots:
    void groupSlut();
    //
private slots:
    void on_pushButton_clicked();
    void on_back_clicked();
};

#endif // CHAT_H
