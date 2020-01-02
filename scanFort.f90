program program1
    implicit none
    character (len = 40) :: filename
    integer :: nlines,sum,average_score,total_students,no_ques
    nlines = 0
    print *, "Enter name of file to read"
    read *, filename

    open(unit=10,file=filename,status="old")
    read(10,*)no_ques
40  read(10,*,END=50)
    nlines=nlines+1
    goto 40

50  total_students = nlines-1

    call reading(filename,no_ques,total_students)
   close(10)
end program program1

!------------------Read file-------------------------
subroutine reading(filename,no_ques,total_students)
    implicit none
    character (len = 40) :: filename
    integer :: no_ques,total_students,nlines,score
    integer :: i,j,count,sum,average
    integer,external :: calculate_score
    integer, dimension(no_ques) :: correct_ans
    integer, dimension(total_students,no_ques+1) :: score_matrix
    integer, dimension(total_students) :: score_track    

    sum = 0
    average = 0

    rewind(10)
    read(10,*)
    read(10,*)correct_ans

    do i = 1,total_students
        read(10,*)score_matrix(i,:)
    end do

    print *,"    Student ID","	    Score"
    print *,"    ======================"
    do i=1,total_students
       score = calculate_score(score_matrix,correct_ans,no_ques,total_students,i)
       print*,score_matrix(i,1),"   "  ,score
        score_track(i) = score
    end do

    call Bsort(score_track)
    print *,"    ======================"
    print *,"Tests graded =",i-1
    print *,"    ======================"
    call freq_counter(score_track,total_students)

    do i=1,total_students	
        sum = sum + score_track(i)
    end do
    average= sum/total_students 	
    print *,"    ===================="	
    print *, "Class Average =",average
    print *,"    ===================="	

end subroutine reading

!------------calculating score----------------------------------

function calculate_score(score_matrix,correct_ans,no_ques,total_students,i)

    integer :: mpq,count,i,total_students,no_ques,calculate_score,j
    integer, dimension(total_students,no_ques) :: score_matrix
    integer, dimension(no_ques) :: correct_ans

    mpq = 100/no_ques
    count = 0 
	do j = 2,no_ques+1
		if(score_matrix(i,j).eq.correct_ans(j-1)) then
		count = count + 1	
		end if   	
	end do

     calculate_score=count * mpq
     
end function calculate_score

!----------Calculating frequency------------------

subroutine freq_counter(score_track,total_students)

    integer, dimension(20) :: score_track  
    integer :: total_students,fcount,k,j
    fcount=1
    k=1

    do while(k.lt.total_students)
	
	do j=1,total_students

	   if(score_track(k).eq.score_track(j)) then
	   	fcount = fcount+1	
	   end if 		
    end do
	index = k
	k=k+fcount-1
	print *,score_track(index),fcount-1
	fcount=1
     end do    
 
    end subroutine freq_counter

    
!-------------sorting the score_track array------------------------

subroutine Bsort(A)
    integer, intent(inout), dimension(15) :: A
    integer :: i,j,temp,n
    n = size(A)
    do i=1,n-1
        do j=1,n-i 
            if(A(j)<A(j+1))then
                temp=A(j)
                A(j)=A(j+1)
                A(j+1)=temp
            end if 
        end do
    end do
end subroutine Bsort
