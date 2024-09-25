import luigi
import subprocess
from datetime import datetime
import os

class RunAutoUpdateDaily(luigi.Task):
    """
    A Luigi Task that runs the auto_update_daily script.
    """

    def output(self):
        # Specify a file to indicate the task completion status
        return luigi.LocalTarget('/home/nas/user_data/suncong/binance_data/logs/auto_update_log_'+datetime.now().strftime('%Y%m%d_%H%M%S')+'.txt')

    def run(self):
        # Run the shell script using subprocess
        script_path = "/home/suncong/work/trading/binance-public-data/shell/auto_update_daily.sh"
        
        with open(self.output().path, 'w') as out_file:
            subprocess.run([script_path], stdout=out_file, stderr=subprocess.STDOUT)


if __name__ == '__main__':
    luigi.build([RunAutoUpdateDaily()], local_scheduler=False,\
                scheduler_host='127.0.0.1', scheduler_port=8082)