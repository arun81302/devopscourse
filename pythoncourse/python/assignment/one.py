n=int(input("enter the number"))
if n>=90:
    grade='A'
elif n>80 and n<89:
    grade='B'
elif n>70 and n<79 :
    grade='C'
elif n>60 and n<69:
    grade='D'       
else:
    grade='F'
print("the grade is:",grade)