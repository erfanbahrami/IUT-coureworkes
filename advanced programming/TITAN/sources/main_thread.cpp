#include "main_thread.h"

main_thread::main_thread(QObject *parent) :
    QThread(parent)
{
}

void main_thread::run(){
    while(true){

        emit main_signal();
        sleep(8);
    }
}
