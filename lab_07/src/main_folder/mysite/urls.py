"""main_folder URL Configuration

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
from . import views

urlpatterns = [
    path('admin/', admin.site.urls),

    path("case2_1/", views.case2_1, name="case2_1"),
    path("case2_2/", views.case2_2, name="case2_2"),
    path("case2_3/", views.case2_3, name="case2_3"),

    path("case3_1/", views.case3_1, name="case3_1"),
    path("case3_2/", views.case3_2, name="case3_2"),
    path("case3_3/", views.case3_3, name="case3_3"),
    path("case3_4/", views.case3_4, name="case3_4"),
]
