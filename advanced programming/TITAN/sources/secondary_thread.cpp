#include "secondary_thread.h"

secondary_thread::secondary_thread(QObject *parent) :
    QThread(parent)
{
}


void secondary_thread::run(){
    while(true){

        emit secondary_signal();
        sleep(8);
    }
}
