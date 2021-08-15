#ifndef START_TITAN_H
#define START_TITAN_H


//#include <QMainWindow>
#include <QNetworkReply>
//#include <QString>
#include <QDialog>
#include "main_thread.h"

namespace Ui {
class start_titan;
}

class start_titan : public QDialog
{
    Q_OBJECT

public:
    explicit start_titan(QWidget *parent = 0);
    ~start_titan();
    main_thread* t_user;
    main_thread* t_group;
    main_thread* t_channel;
    bool cc();
    void chapOffline();

private slots:
    void replyfinished(QNetworkReply * reply);
    void replyfinished2(QNetworkReply * reply);
    void replyfinished3(QNetworkReply * reply);
    void replyfinished4(QNetworkReply * reply);
    void replyfinished5(QNetworkReply * reply);
    void replyfinished6(QNetworkReply * reply);
    void replyfinished7(QNetworkReply * reply);
    void replyfinished8(QNetworkReply * reply);
   // void replyfinished13(QNetworkReply * reply);

    void on_logout_clicked();
    void on_create_group_clicked();
    void on_create_channel_clicked();
    void on_join_group_clicked();
    void on_join_channel_clicked();

    void on_pushButton_clicked();
    void on_pushButton_2_clicked();
    void on_pushButton_3_clicked();

private:
    Ui::start_titan *ui;

public slots:
    void userSlot();
    void groupSlot();
    void channelSlot();
};

#endif // START_TITAN_H
