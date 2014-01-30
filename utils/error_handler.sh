#!/bin/bash
error_out() {
    echo "I have failed you miserably! I'm so sorry. :( Check ~/.walkins/logfile for details."
    notify_error
    exit 3
}
