#ifndef CHAT3_H
#define CHAT3_H

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
class chat3;
}

class chat3 : public QWidget
{
    Q_OBJECT

public:
    QString sended_username;
    void setName(QString);

    explicit chat3(QWidget *parent = 0);
    ~chat3();
    secondary_thread * t_channel;

    void chapOffline();

    void replyfinished13(QNetworkReply * reply);
    void replyfinished14(QNetworkReply * reply);

    bool cc();


private:
    Ui::chat3 *ui;
public slots:

    void channelSlut();
private slots:
    void on_pushButton_clicked();
    void on_back_clicked();
};

#endif // CHAT3_H
