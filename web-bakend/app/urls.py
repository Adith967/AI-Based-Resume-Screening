"""AI_based_resume_screening URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from .import views

urlpatterns = [
    path('admin/', admin.site.urls),
    path('',views.index),
    path('login',views.login),
    path('admin_home',views.admin_home),
    path('admin_dashboard',views.admin_dashboard),
    path('admin_view_jobdescription',views.admin_view_jobdescription),
    path('admin_view_user',views.admin_view_user),
    path('admin_user',views.admin_user),
    path('register',views.register),
    path('accept_hr/<id>',views.accept_hr),
    path('reject_hr/<id>',views.reject_hr),
    path('hr_home',views.hr_home),
    path('hr_jobdescription',views.hr_jobdescription),
    path('admin_view_jobdescription',views.admin_view_jobdescription),
    path('hr_reviewresume',views.hr_reviewresume),
    path('hr_view_jobdescription',views.hr_view_jobdescription),
    path('hr_interviewsched',views.hr_interviewsched),
    path('hr_add_interview_post',views.hr_add_interview_post),
    path('hr_view_schedule_view',views.hr_view_schedule_view),
    path('hr_view_apply/<id>',views.hr_view_apply),

    path('user_reg',views.user_reg),
    path('flutter_login',views.flutter_login),
    path('view_jobs',views.view_jobs),
    path('view_jobs_more',views.view_jobs_more),
    path('user_view_profile',views.user_view_profile),
    path('user_upload_file',views.user_upload_file),
    path('user_view_interview',views.user_view_interview),

   
    

]
