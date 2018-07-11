from django.http import HttpResponseRedirect, HttpResponse
from django.shortcuts import render
from django.template import loader
from madrigalWeb import madrigalWeb
from polls.models import Question
import os
import sys
import time
import numpy as np 
from numpy import arange,ndarray  # gives Matlab-like N-dimensional array functionality
import os
import h5py  # read/write HDF5 files
from datetime import datetime
from typing import List, Tuple  # typing is the Python type hinting module
import matplotlib.pyplot as plt
from matplotlib.pyplot import figure,imshow,xticks
import mpld3 
from math import floor
import json
import matplotlib.dates as mdates
from plotly import __version__
from plotly.offline import download_plotlyjs, init_notebook_mode, plot, iplot
import plotly.graph_objs as go
import numpy as np
import plotly.tools as tls
import plotly.plotly as py
from polls.forms import InputForm
from django.utils import timezone

user_fullname = 'Ashaki Gumbs'
user_email = 'agumbs@bu.edu'
user_affiliation = 'Boston University'


def index(request):
    # if this is a POST request we need to process the form data
    if request.method == 'POST':
        # create a form instance and populate it with data from the request:
        form = InputForm(request.POST)
        # check whether it's valid:
        if form.is_valid():
            location = form.cleaned_data['location']
            fromdate= form.cleaned_data['fromdate']
            todate= form.cleaned_data['todate']
            if (location == 'SRI'):
                madrigalUrl = 'http://isr.sri.com/madrigal'
            else:
                madrigalUrl = 'http://madrigal.haystack.mit.edu/madrigal'
            testData = madrigalWeb.MadrigalData(madrigalUrl)
            expList = testData.getExperiments(61, fromdate.year,fromdate.month,fromdate.day,0,0,0,
                todate.year,todate.month,todate.day,0,0,0, local=0)
            Question.objects.all().delete()
            for i in range(len(expList)):
                q = Question(question_text = expList[i].name, pub_date = timezone.now() , madrigalUrl = expList[i].madrigalUrl,
                         name = expList[i].name, realUrl = expList[i].realUrl, 
                         url = expList[i].url)
                q.save()


            # process the data in form.cleaned_data as required
            # ...
            # redirect to a new URL:
            return HttpResponseRedirect('/polls/listexp/')

    # if a GET (or any other method) we'll create a blank form
    else:
        form = InputForm()

    return render(request, 'polls/inputinfo.html', {'form': form})


def listexp(request):
    latest_expList = Question.objects.all()
    template = loader.get_template('polls/listexp.html')
    context = {'latest_expList': latest_expList}

    return HttpResponse(template.render(context, request))

# def fndwnld(request, experimentid):
#   fileList = newcgiurl.getExperimentFiles(experimentid)
#   return render(request, 'polls/fndwnld.html')



