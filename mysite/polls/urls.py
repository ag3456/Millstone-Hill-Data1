from django.urls import path

from . import views

urlpatterns = [
	
    path('', views.index, name='index'),
    path('listexp/', views.listexp, name='listexp'),
    #path('<int:experimentid>', views.fndwnld, name='fndwnld'),
]