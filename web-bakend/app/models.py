from django.db import models

# Create your models here.
class Login(models.Model):
    username = models.CharField(max_length=200)
    password = models.CharField(max_length=200)
    usertype = models.CharField(max_length=200)

class HR(models.Model):
    LOGIN = models.ForeignKey(Login, on_delete=models.CASCADE)
    fullname = models.CharField(max_length=100)
    hr_email = models.CharField(max_length=100)
    company_name = models.CharField(max_length=200)
    contact_no = models.CharField(max_length=200)
    role = models.CharField(max_length=200)
    hrstatus = models.CharField(max_length=200)


class Jobdescription(models.Model):
    HR_ID= models.ForeignKey(HR, on_delete=models.CASCADE)
    job_title=models.CharField(max_length=200)
    job_desc=models.CharField(max_length=1000)
    required_skills=models.CharField(max_length=200)
    req_experience=models.CharField(max_length=200)
    req_education=models.CharField(max_length=200)
    job_location=models.CharField(max_length=200)
    jobtype=models.CharField(max_length=200)

 


class Candidatereg(models.Model):
    LOGIN = models.ForeignKey(Login, on_delete=models.CASCADE)
    full_name = models.CharField(max_length=200)
    email = models.CharField(max_length=200)
    contact_no = models.CharField(max_length=200)
    skill= models.CharField(max_length=200)
    education=models.CharField(max_length=200)
    exp=models.CharField(max_length=200)
    created_at=models.CharField(max_length=200)

class Interview(models.Model):
    JOB_ID = models.ForeignKey(Jobdescription,on_delete=models.CASCADE)
    CANDIDATE_ID =models.ForeignKey(Candidatereg,on_delete=models.CASCADE)
    interview_date = models.CharField(max_length=200)
    interview_time = models.CharField(max_length=200)
    interview_sts = models.CharField(max_length=200)

class Resume(models.Model):
    JOB_id =models.ForeignKey(Jobdescription,on_delete=models.CASCADE)
    CANDIDATE_ID =models.ForeignKey(Candidatereg,on_delete=models.CASCADE)
    resume_file= models.CharField(max_length=200)
    par_skills = models.CharField(max_length=200)
    exp_yr= models.CharField(max_length=200)
    education=models.CharField(max_length=200)
    job_role=models.CharField(max_length=200)
    uploaded_at=models.CharField(max_length=200)
    resume_summary=models.CharField(max_length=1000)

class Resumereview(models.Model):
    JOB_id =models.ForeignKey(Jobdescription,on_delete=models.CASCADE)
    CANDIDATE_ID =models.ForeignKey(Candidatereg,on_delete=models.CASCADE)
    RESUME =models.ForeignKey(Resume,on_delete=models.CASCADE)
    review_status=models.CharField(max_length=200)
    rating=models.CharField(max_length=200)
    comments=models.CharField(max_length=200)
    

class Apply_Jobs(models.Model):
    JOB_id =models.ForeignKey(Jobdescription,on_delete=models.CASCADE)
    CANDIDATE_ID =models.ForeignKey(Candidatereg,on_delete=models.CASCADE)
    applydate=models.CharField(max_length=200)
    status=models.CharField(max_length=200)
