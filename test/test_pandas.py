import pandas as pd
from pandas import util


def test_pandas():
    try:
        df = util.testing.makeDataFrame()
        df.head()
    except:
        print('Pandas canceled or failed')
        return
    
    print('Pandas worked correctly')
