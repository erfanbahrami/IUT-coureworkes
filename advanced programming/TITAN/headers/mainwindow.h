#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QMainWindow>
#include <QNetworkReply>
#include <QString>
namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();
    QString username;
    QString password;
    bool cc();

private slots:
    void on_signup_button_clicked();
    void replyfinished(QNetworkReply *);
    void replyfinished2(QNetworkReply *);
    void on_login_button_clicked();

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
