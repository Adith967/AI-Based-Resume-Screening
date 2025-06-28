import datetime

from django.core.files.storage import FileSystemStorage
from django.http import JsonResponse
from django.shortcuts import render,HttpResponse
from .models import *

# Create your views here.
def index(request):
    return render(request,'public/index.html')

def login(request):
    if 'submit' in request.POST:
        username=request.POST['username']
        password=request.POST['password']
        
        if Login.objects.filter(username=username,password=password).exists():
            q=Login.objects.get(username=username,password=password)
            request.session['login_id']=q.pk
            login_id=request.session['login_id']
            if q.usertype=='admin':
                return HttpResponse(f"<script>alert('admin login success');window.location='/admin_home'</script>")
            if q.usertype=='HR':
                q1 = HR.objects.get(LOGIN_id=login_id)
                if q1:
                    request.session['hr_id']=q1.pk
                    return HttpResponse(f"<script>alert('HR login success');window.location='/hr_home'</script>")
                else:
                    return HttpResponse(f"<script>alert('invalid HR login');window.location='/login'</script>")
            # if q.usertype=='staffs':
            #     q1 = Staffs.objects.get(LOGIN_id=login_id)
            #     if q1:
            #         request.session['staffs_id']=q1.pk
            #         return HttpResponse(f"<script>alert('staffs login success');window.location='/staffs_home'</script>")
            #     else:
            #         return HttpResponse(f"<script>alert('invalid staffs login');window.location='/login'</script>")
        else:
             return HttpResponse(f"<script>alert('invalid..');window.location='/login'</script>")
    return render(request,'public/login.html')

def register(request):
    if "submit" in request.POST:
        username=request.POST['username']
        password=request.POST['password']
        fullname=request.POST['fullname']
        hr_email=request.POST['hr_email']
        company_name=request.POST['company_name']
        contact_no=request.POST['contact_no']
        role=request.POST['role']
        hrstatus=request.POST['hrstatus']
        q=Login(username=username,password=password,usertype="pending")
        q.save()
        q1=HR(LOGIN_id=q.pk,fullname=fullname,hr_email=hr_email,company_name=company_name,contact_no=contact_no,role=role,hrstatus=hrstatus)
        q1.save()
        return HttpResponse(f"<script>alert('Register Successfully...');window.location='/login'</script>")
    return render(request,'public/register.html')

def admin_home(request):
    return render(request,'admin/adminindex.html')

def admin_view_jobdescription(request):
     data=Jobdescription.objects.all()
     return render(request,'admin/admin_view_jobdescription.html',{'data':data})

def admin_view_user(request):
    data=HR.objects.all()
    return render(request,'admin/admin_view_user.html',{'data':data})




def admin_user(request):
    data=Candidatereg.objects.all()
    return render(request,'admin/users.html',{'data':data})


def accept_hr(request,id):
    data=Login.objects.get(id=id)
    data.usertype="HR"
    data.save()
    return HttpResponse(f"<script>alert('Hr accepeted...');window.location='/admin_view_user'</script>")
def reject_hr(request,id):
    data=Login.objects.get(id=id)
    data.usertype="pending"
    data.save()
    return HttpResponse(f"<script>alert('Rejected...');window.location='/admin_view_user'</script>")

def admin_dashboard(request):
    
    return render(request,'admin/admin_dashboard.html')
def hr_home(request):
    return render(request,'HR/hr_home.html')
def hr_jobdescription(request):
    if "submit" in request.POST:
        job_title=request.POST['job_title']
        job_desc=request.POST['job_desc']
        required_skills=request.POST['required_skills']
        req_experience=request.POST['req_experience']
        req_education=request.POST['req_education']
        job_location=request.POST['job_location']
        jobtype=request.POST['jobtype']
        q=Jobdescription(HR_ID_id=request.session['hr_id'],job_title=job_title,job_desc=job_desc,required_skills=required_skills,req_experience=req_experience,req_education=req_education,job_location=job_location,jobtype=jobtype)
        q.save()
       
        return HttpResponse(f"<script>alert('Job added  Successfully...');window.location='/hr_jobdescription'</script>")

    
    return render(request,'HR/hr_jobdescription.html')
def hr_reviewresume(request):
    data=Resumereview.objects.all()
    return render(request,'HR/hr_reviewresume.html',{'data':data})


def hr_view_jobdescription(request):
    data = Jobdescription.objects.filter(HR_ID__LOGIN_id=request.session['login_id'])
    return render(request, 'HR/hrview_jobdescription.html', {'data': data})


def hr_interviewsched(request):

    data=Candidatereg.objects.all()
    data2=Jobdescription.objects.filter(HR_ID__LOGIN_id=request.session['login_id'])
    return render(request,'HR/hr_interviewsched.html',{'data':data,'data2':data2})



def hr_view_schedule_view(request):
    a=Interview.objects.filter(JOB_ID__HR_ID__LOGIN_id=request.session['login_id'])
    return render(request,'HR/view interviewschedule.html',{'data':a})


def hr_add_interview_post(request):
    name=request.POST['name']
    interview_date=request.POST['interview_date']
    interview_time=request.POST['interview_time']
    interview_mode=request.POST['interview_mode']
    job=request.POST['job']
    a=Interview()
    a.CANDIDATE_ID=Candidatereg.objects.get(id=name)
    a.JOB_ID=Jobdescription.objects.get(id=job)
    a.interview_time=interview_time
    a.interview_date=interview_date
    a.interview_sts=interview_mode
    a.save()
    return HttpResponse(f"<script>alert(' Added  Successfully...');window.location='/hr_interviewsched'</script>")


# def flutter_login(request):
#     username = request.POST['username']
#     password = request.POST['psw']
#     a = Login.objects.filter(username=username, password=password)
#     if a.exists():
#         b = Login.objects.get(username=username, password=password)
#         if b.usertype == 'user':
#
#             return JsonResponse({"status": "ok", "lid": str(b.id), 'type': 'user'})
#
#
#         else:
#             return JsonResponse({"status": "no"})
#
#
#     else:
#
#         return JsonResponse({"status": "no"})


from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.contrib.auth import authenticate
from .models import Login  # Ensure this model exists and is correctly defined

@csrf_exempt
def flutter_login(request):
    if request.method == 'POST':
        username = request.POST.get('username')
        password = request.POST.get('psw')

        # print(f"Received username: {username}, password: {password}")

        # Check if username and password exist in the Login table
        user = Login.objects.filter(username=username).first()

        if user:
            print(f"User found in database: {user.username}, usertype: {user.usertype}")

            if user.password == password:  # Ensure password hashing is considered if needed
                if user.usertype == 'user':
                    return JsonResponse({"status": "ok", "lid": str(user.id), 'type': 'user'})
                else:
                    print("Login error: Invalid user type")
                    return JsonResponse({"status": "no", "message": "Invalid user type"})
            else:
                print("Login error: Incorrect password")
                return JsonResponse({"status": "no", "message": "Incorrect password"})
        else:
            print("Login error: User not found")
            return JsonResponse({"status": "no", "message": "User not found"})

    return JsonResponse({"status": "no", "message": "Invalid request method"})


def user_reg(request):
    full_name=request.POST['full_name']
    email=request.POST['email']
    contact_no=request.POST['contact_no']
    skill=request.POST['skill']
    education=request.POST['education']
    exp=request.POST['exp']

    password=request.POST['password']




    aa=Login.objects.filter(username=email)
    if aa.exists():
        return JsonResponse({"status": "not ok"})

    lobj = Login()
    lobj.username = email
    lobj.password = password
    lobj.usertype = 'user'
    lobj.save()


    f = Candidatereg()
    f.full_name = full_name
    f.email = email
    f.contact_no = contact_no
    f.skill = skill
    f.education = education
    f.created_at = datetime.datetime.now().today()

    f.LOGIN = lobj
    f.exp = exp
    f.save()

    return JsonResponse({"status": "ok"})



def view_jobs(request):
    l=[]
    a = Jobdescription.objects.all().order_by('-id')

    for i in a:
        l.append({
            'id':str(i.id),'HR_ID':i.HR_ID.fullname,'job_title':str(i.job_title),'job_desc':str(i.job_desc),
            'required_skills':str(i.required_skills),'req_experience':str(i.req_experience),
            'req_education':str(i.req_education),'job_location':str(i.job_location),'jobtype':str(i.jobtype)
        })
    print(l)
    return JsonResponse({"status": "ok",'data':l})


def view_jobs_more(request):
    jid=request.POST['jid']
    l=[]
    a = Jobdescription.objects.filter(id=jid).order_by('-id')

    for i in a:
        l.append({
            'id':str(i.id),'HR_ID':i.HR_ID.fullname,'job_title':str(i.job_title),'job_desc':str(i.job_desc),
            'required_skills':str(i.required_skills),'req_experience':str(i.req_experience),
            'req_education':str(i.req_education),'job_location':str(i.job_location),'jobtype':str(i.jobtype)
        })
    print(l)
    return JsonResponse({"status": "ok",'data':l})



def user_view_profile(request):
    lid=request.POST['lid']
    i=Candidatereg.objects.get(LOGIN_id=lid)
    return JsonResponse({'status':'ok','full_name':str(i.full_name),'email':str(i.email),
                         'contact_no':str(i.contact_no),'skill':str(i.skill),
                         'education':str(i.education),'exp':str(i.exp)


                         })

#
# import datetime
# from django.core.files.storage import FileSystemStorage
# from django.http import JsonResponse
# from PyPDF2 import PdfReader
# from .models import Resume, Candidatereg
#
# def user_upload_file(request):
#     print(request.POST)
#     lid = request.POST['lid']
#     file = request.FILES['file']
#
#
#     fs = FileSystemStorage()
#     path = fs.save(file.name, file)
#     file_path = fs.path(path)
#
#     pdf_text = ""
#     print(file_path,'======filepath=========')
#     with open(file_path, "rb") as pdf_file:
#         print(file_path,'path222')
#
#         reader = PdfReader(pdf_file)
#         print(len(reader.pages))
#         for page in reader.pages:
#             if page.extract_text():
#                 print(page.extract_text())
#                 pdf_text += page.extract_text() + "\n"
#
#     resume_summary = pdf_text[:500] if len(pdf_text) > 500 else pdf_text
#
#     candidate = Candidatereg.objects.get(LOGIN_id=lid)
#     resume = Resume(
#         CANDIDATE_ID=candidate,
#         resume_file=path,
#         uploaded_at=datetime.datetime.now().date(),
#         resume_summary=resume_summary
#     )
#     resume.save()
#
#     return JsonResponse({"status": "ok", "pdf_text": pdf_text})



import datetime
import pdfplumber
from django.core.files.storage import FileSystemStorage
from django.http import JsonResponse
from sentence_transformers import SentenceTransformer
from .models import Resume, Candidatereg

# Load the Sentence Transformer model (BERT-based)
model = SentenceTransformer('all-MiniLM-L6-v2')

def user_upload_file(request):
    lid = request.POST['lid']
    jid = request.POST['jid']
    file = request.FILES['file']

    # Save the file using FileSystemStorage
    fs = FileSystemStorage()
    path = fs.save(file.name, file)
    file_path = fs.path(path)  # Get the full path of the saved file

    # Extract text from PDF
    pdf_text = ""
    with pdfplumber.open(file_path) as pdf:
        for page in pdf.pages:
            text = page.extract_text()
            if text:
                pdf_text += text + "\n"

    # Generate embeddings using SentenceTransformer
    embedding = model.encode(pdf_text)

    # Generate a summarized version (first 500 characters)
    resume_summary = pdf_text[:500] if len(pdf_text) > 500 else pdf_text

    # Save resume details in the database
    candidate = Candidatereg.objects.get(LOGIN_id=lid)
    resume = Resume(
        CANDIDATE_ID=candidate,
        resume_file=path,
        JOB_id=Jobdescription.objects.get(id=jid),
        uploaded_at=datetime.datetime.now().date(),
        resume_summary=resume_summary  # Store extracted summary
    )
    resume.save()

    return JsonResponse({"status": "ok", "pdf_text": pdf_text, "embedding": embedding.tolist()})



def hr_view_apply(request,id):
    a=Resume.objects.filter(JOB_id_id=id)

    aa=Jobdescription.objects.get(id=id)

    job_title=aa.job_title
    job_desc=aa.job_desc
    required_skills=aa.required_skills
    req_experience=aa.req_experience
    req_education=aa.req_education
    job_location=aa.job_location
    jobtype=aa.jobtype

    mydescription= 'Job title is '+job_title+". Job description is "+ job_desc +". Required skills are "+required_skills+". Required experince is "+req_experience+"."
    mydescription=mydescription+ "Education qualification is "+req_education +". Job type "+jobtype

    score=[]
    h=[]

    for i in a:

        h.append(i)

        from sentence_transformers import SentenceTransformer
        from sklearn.metrics.pairwise import cosine_similarity

        # Load a pre-trained model
        model = SentenceTransformer('paraphrase-MiniLM-L6-v2')

        # Define two sentences
        sentence1 = mydescription
        sentence2 = i.resume_summary

        # Generate embeddings for both sentences
        embedding1 = model.encode(sentence1)
        embedding2 = model.encode(sentence2)

        # Compute cosine similarity
        similarity = cosine_similarity([embedding1], [embedding2])
        score.append(similarity)

        print(f"Cosine Similarity: {similarity[0][0]}")

    print(a,'========')


    for i in range(0,len(h)):

        for j in range(0,len(h)):

            if score[i]>score[j]:

                temp=score[i]
                score[i]=score[j]
                score[j]=temp

                temp=h[i]
                h[i]=h[j]
                h[j]=temp







    return render(request,'HR/view apply.html',{'data':h})



def user_view_interview(request):
    lid=request.POST['lid']

    a=Interview.objects.filter(CANDIDATE_ID__LOGIN_id=lid)
    l=[]
    for i in a:
        l.append({
            'id':str(i.id),'interview_date':str(i.interview_date),'job_title':str(i.JOB_ID.job_title),'HR_ID':str(i.JOB_ID.HR_ID.fullname),
            'interview_time':str(i.interview_time),'jobtype':str(i.interview_sts),
        })
    print(l)
    return  JsonResponse({'status':'ok','data':l})