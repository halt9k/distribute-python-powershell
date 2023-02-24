import glob
import os
import subprocess
import sys

sys.path.append(os.path.dirname(os.path.dirname(__file__)))

from src.test_pandas import test_pandas
from tkinter import filedialog


def test_tkinter():
    try:
        path = filedialog.askopenfilename(initialfile=__file__, title='Select any file')
    except:
        print('Tkinter canceled or failed')
        return
    
    print('Tkinter worked correctly')


if __name__ == '__main__':
    test_tkinter()
    test_pandas()
