import sys
sys.path.append('wsd')
from nltk.wsd import lesk

print dir(lesk)
print lesk(u'', u'fill')
