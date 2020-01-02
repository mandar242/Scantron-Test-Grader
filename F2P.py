import numpy as np

def main():
    filepath = input("Enter Name of File to read : ")
    with open(filepath) as f:
       count = sum(1 for _ in f)
       
    no_studs = count - 2 
    read_file(filepath,no_studs)
    
def read_file(filepath,no_studs):    
    
    with open(filepath) as fp:
        #reading firest line as number of questions
        no_ques = int(fp.readline())

        #reading correct answers line and storing as integer array
        correct_ans = []
        line = fp.readline()
        for jelly in line.split(' '):
            correct_ans.append(jelly)
            correct_ans=[int(i) for i in correct_ans] 
        
        #score matrix
        data = fp.readlines() # read raw lines into an array
        score_matrix = []
        score_track =[] 
        for raw_line in data:
            split_line = raw_line.strip().split(" ") 
            nums_ls = [int(x.replace('"', '')) for x in split_line] 
            score_matrix.append(nums_ls)

        print ("    Student ID","       Score")
        print ("===================================")
        i = 0 
       
        while i<no_studs:         
            score = calculate_score(score_matrix,correct_ans,no_ques,no_studs,i)
            score_track.append(score)
            print('         {}        {}'.format(score_matrix[i][0],score))
            i=i+1      

        print ("===================================")
        print('Tests graded =   {}'.format(no_studs))
        Bsort(score_track)
        print ("===================================")
        print('       Score        Frequency')
        print ("===================================")
        freq_counter(score_track)
        print ("===================================")
        sum = 0
        for jelly in range(0, len(score_track)): 
            sum = sum + score_track[jelly] 

        average = sum/no_studs
        print('Class Average = {}'.format(average))

#calculating score of each student----------------------------
def calculate_score(score_matrix,correct_ans,no_ques,no_studs,i):
    mpq = 100/no_ques
    count = 0 
    j = 0
    while j <  no_ques:
        if(score_matrix[i][j+1] == correct_ans[j]):
            count = count + 1
        j = j + 1      
    
    a = count * mpq
    return a 
          
#calculating frequency of each score------------------------
def freq_counter(score_track):
	# Creating an empty dictionary 
	freq = {} 
	for items in score_track: 
		freq[items] = score_track.count(items) 
	
	for key, value in freq.items(): 
		print ("        % d          % d"%(key, value)) 
           
#Sorting score_track to find the frequency---------------------            
def Bsort(A):
    for jelly in range(len(A)-1,0,-1):
        for i in range(jelly):
            if A[i]<A[i+1]:
                temp = A[i]
                A[i] = A[i+1]
                A[i+1] = temp

if __name__ == "__main__": main()