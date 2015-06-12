C CSCI3180 Principles of Programming Languages

C --- Declaration ---

C I declare that the assignment here submitted is original except for source
C material explicitly acknowledged. I also acknowledge that I am aware of
C University policy and regulations on honesty in academic work, and of the
C disciplinary guidelines and procedures applicable to breaches of such policy
C and regulations, as contained in the website
C http://www.cuhk.edu.hk/policy/academichonesty/

C Assignment 1

      program crushing
C tscore: target score
C cscore: score of current stage
C rf_idx(80): row index of each column of roof
C score: total score
C spec(100,80): storing which position has special candy, '1' means '#',
C               '2' means '@'
C spec0(100,80): store a copy of 'spec' before crushing, for exploding
C                special candies
C arr1(100,80): storing horizontal matching for finding L/T matching
C arr2(100,80): storing vertical matching for finding L/T matching
C str: for score printing
      integer roof_r, roof_c, wall_r, wall_c, swap(2,2), tscore, cscore,
     +        rf_idx(80), score, spec(100,80), spec0(100,80), cont
      character roof(100,80), wall(100,80), arr1(100,80), arr2(100,80)
      character*5 str
      character*255 infile
      logical exfile
      data arr1/8000*'0'/, arr2/8000*'0'/, spec/8000*0/

C open input file
      call getarg(1, infile)
      inquire(file=infile, exist=exfile)
      if (exfile) goto 5
      write(*,*) 'error: No such file'
      goto 9999
    5 open(1, file=infile, status='old')

C read initial value from input file
      read(1,*) roof_r, roof_c
      read(1,*) wall_r, wall_c
      read(1,*) swap(1,1), swap(1,2), swap(2,1), swap(2,2)
      read(1,*) tscore

C check if the swapping is valid
      if (swap(1,1) .lt. 1 .or. swap(1,1) .gt. wall_r .or.
     +    swap(2,1) .lt. 1 .or. swap(2,1) .gt. wall_r .or.
     +    swap(1,2) .lt. 1 .or. swap(1,2) .gt. wall_c .or.
     +    swap(2,2) .lt. 1 .or. swap(2,2) .gt. wall_c) goto 6
      goto 7
    6 write(*,*) 'error: Wrong coordinates'
      goto 9999

C read candies into roof
    7 call read_r(roof, roof_r, roof_c)

C initialize roof column index
      i = 1
   11 rf_idx(i) = roof_r
      i = i + 1
      if (i .le. roof_c) goto 11

C initialize wall
      i = 1
   12 j = 1
   13 wall(i,j) = '0'
      j = j + 1
      if (j .le. wall_c) goto 13
      i = i + 1
      if (i .le. wall_r) goto 12

      call ldcan(roof, wall, roof_r, roof_c, wall_r, rf_idx, cscore)
      call goswap(wall, swap)

C main loop
      score = 0
  800 print *,'wall A:'
      call printw(wall, wall_r, wall_c)
      call scan_s(wall, wall_r, wall_c, spec)
      call scan_s(wall, wall_r, wall_c, spec0)
      call find12(wall, wall_r, wall_c, swap, arr1, arr2, spec)
C       print *,'arr1:'
C       call printw(arr1, wall_r, wall_c)
C       print *,'arr2:'
C       call printw(arr2, wall_r, wall_c)
      call findlt(wall, wall_r, wall_c, swap, arr1, arr2, spec, 1)
      call findst(wall, wall_r, wall_c, swap, arr1, arr2, spec, 1)
      call findlt(wall, wall_r, wall_c, swap, arr1, arr2, spec, 0)
      call findst(wall, wall_r, wall_c, swap, arr1, arr2, spec, 0)
      call g_spec(wall, wall_r, wall_c, spec)
      print *,'wall B:'
      call printw(wall, wall_r, wall_c)
      call c_spec(wall, wall_r, wall_c, spec, spec0)
      print *,'wall C:'
      call printw(wall, wall_r, wall_c)
      call ldcan(roof, wall, roof_r, roof_c, wall_r, rf_idx, cscore)
      score = score + cscore
      write(str,'(I5)') score
      print *,'score: '//str
      call result(wall, wall_r, wall_c, tscore, cscore, score, cont)
      if (cont .eq. 1) goto 800

      close(1)

      stop
 9999 end


C read candies into roof
      subroutine read_r(roof, roof_r, roof_c)
      character roof(100,80)
      character*81 buf
      integer roof_r, roof_c
      i = 1
 1001 read(1,'(A)') buf
      j = 1
 1000 roof(i,j) = buf(j:j)
      j = j + 1
      if (j .le. roof_c) goto 1000
      i = i + 1
      if (i .le. roof_r) goto 1001
      end


C detect end game and print result
      subroutine result(wall, wall_r, wall_c, tscore, cscore, score,
     +                  cont)
      character wall(100,80)
      character*5 intstr
      character*81 buf
      character*255 f_name
      integer wall_r, wall_c, tscore, cscore, score, cont, win
      cont = 0
      if (score .ge. tscore) goto 801
      if (cscore .eq. 0) goto 803
      cont = 1
      goto 802
  801 win = 1
      goto 811
  803 win = 0
  811 write(intstr, '(I5)') tscore
      write(f_name, '(A)') 'for'//intstr(5-numdig(tscore)+1:5)//'.txt'
      open(2, file=f_name)

      i = 1
 1011 buf = ''
      j = 1
 1010 buf(j:j) = wall(i,j)
      j = j + 1
      if (j .le. wall_c) goto 1010
      write(2, '(A,A)') buf(1:lentrm(buf)), achar(13)
      i = i + 1
      if (i .le. wall_r) goto 1011

      if (win .eq. 1) goto 813
      write(2,'(A,A)') 'Jimmy is locked forever!', achar(13)
      goto 814
  813 write(2,'(A,A)') 'Jimmy is safe!', achar(13)
  814 close(2)
  802 end


C scan for positions of special candies and store them to 'spec'
      subroutine scan_s(wall, wall_r, wall_c, spec)
      character wall(100,80)
      integer wall_r, wall_c, spec(100,80)
C set all elements of 'spec' to 0
      i = 1
  804 j = 1
  805 spec(i,j) = 0
      j = j + 1
      if (j .le. wall_c) goto 805
      i = i + 1
      if (i .le. wall_r) goto 804

      i = 1
  700 j = 1
  701 if (wall(i,j) .eq. '#') goto 702
      if (wall(i,j) .eq. '@') goto 703
      goto 704
  702 spec(i,j) = 1
      goto 704
  703 spec(i,j) = 2
  704 j = j + 1
      if (j .ge. 1 .and. j .le. wall_c) goto 701
      i = i + 1
      if (i .ge. 1 .and. i. le. wall_r) goto 700
      end


C proceed the swaping
      subroutine goswap(wall, swap)
      integer swap(2,2)
      character wall(100,80), tmp
      tmp = wall(swap(1,1),swap(1,2))
      wall(swap(1,1),swap(1,2)) = wall(swap(2,1),swap(2,2))
      wall(swap(2,1),swap(2,2)) = tmp
      end


C load candies from roof to wall, start from bottom-left, replace '0'
C with candies
      subroutine ldcan(roof, wall, roof_r, roof_c, wall_r, rf_idx,
     +                 cscore)
      character roof(100,80), wall(100,80), retval, buffer(100), c
      integer roof_r, roof_c, wall_r, rf_idx(80), cscore
      data buffer/100*'0'/

      cscore = 0
      m = 1
  200 n = wall_r
      l = 1
  201 c = wall(n,m)
      if ((c .ge. '1' .and. c .le. '9') .or. c .eq. '@' .or. c .eq. '#')
     +   goto 202
      cscore = cscore + 1
      goto 203
  202 buffer(l) = c
      l = l + 1
  203 n = n - 1
      if (n .ge. 1) goto 201

C copy buffer to the column in order to 'pack' the column
      kk = wall_r
  205 wall(kk,m) = buffer(wall_r-kk+1)
      kk = kk - 1
      if (kk .ge. 1) goto 205

C set all elements of 'buffer' to '0'
      kk = 1
  806 buffer(kk) = '0'
      kk = kk + 1
      if (kk .le. wall_r) goto 806

      m = m + 1
      if (m .le. roof_c) goto 200

C load candies to the 'empty' space of the column
      i = 1
   20 j = wall_r
   21 if (wall(j,i) .ne. '0') goto 22
      call nxtcan(roof, roof_r, rf_idx, i, retval)
      wall(j,i) = retval
   22 j = j - 1
      if (j .ge. 1) goto 21
      i = i + 1
      if (i .le. roof_c) goto 20
      end


C get next candy from a column of the roof
C c_idx: specify which column you are loading for
C retval: return the next candy
      subroutine nxtcan(roof, roof_r, rf_idx, c_idx, retval)
      character roof(100,80), retval
      integer roof_r, rf_idx(80), c_idx, r_idx
      r_idx = rf_idx(c_idx)
      retval = roof(r_idx, c_idx)
      r_idx = r_idx - 1
      if (r_idx .lt. 1) goto 30
      goto 31
   30 r_idx = roof_r
   31 rf_idx(c_idx) = r_idx
      end


C print out the whole wall
      subroutine printw(wall, wall_r, wall_c)
      character wall(100,80)
      character*81 buf
      integer wall_r, wall_c
      i = 1
 1021 buf = ''
      j = 1
 1020 buf(j:j) = wall(i,j)
      j = j + 1
      if (j .le. wall_c) goto 1020
      write(*,*) buf(1:lentrm(buf))
      i = i + 1
      if (i .le. wall_r) goto 1021
      end


C produce arr1 and arr2
      subroutine find12(wall, wall_r, wall_c, swap, arr1, arr2, spec)
      character wall(100,80), arr1(100,80), arr2(100,80)
      integer swap(2,2), wall_r, wall_c, count, spec(100,80), super
C set all elements of 'arr1' and 'arr2' to 0
      i = 1
  807 j = 1
  808 arr1(i,j) = '0'
      arr2(i,j) = '0'
      j = j + 1
      if (j .le. wall_c) goto 808
      i = i + 1
      if (i .le. wall_r) goto 807

      call travel(wall, wall_r, wall_c, swap, arr1, arr2, 1, 1, 3, 1,
     +            count, spec, 0, super)
      end


C find all the straight matching
C s = 1: find only the super matching
C s = 0: find all the matching
      subroutine findst(wall, wall_r, wall_c, swap, arr1, arr2, spec, s)
      character wall(100,80), arr1(100,80), arr2(100,80)
      integer swap(2,2), wall_r, wall_c, count, spec(100,80), s, super
      call travel(wall, wall_r, wall_c, swap, arr1, arr2, 1, 1, 3, 3,
     +            count, spec, s, super)
      end


C find all the L/T matching
C s = 1: find only the super matching
C s = 0: find all the matching
C count: number of directions have 3 or more matching candies
C is_sup: is it a super matching
C numsup: prevent 2 or more special candies in one matching
C n_dir: number of direction should looking for
C arrsup(4): storing which direction has super matching
C order(100,80,7): storing matching according top-left most order
C order(:,:,1:4): storing cnt_d(4)
C order(:,:,5:6): storing intersect position
C order(:,:,7): storing whether it is a 'cross' matching
C add_at: do I need to add the '@' back
      subroutine findlt(wall, wall_r, wall_c, swap, arr1, arr2, spec, s)
      character wall(100,80), arr1(100,80), arr2(100,80)
      integer swap(2,2), wall_r, wall_c, cnt_d(4), count, spec(100,80),
     +        s, super, n_dir, arrsup(4), order(100,80,7), add_at

  523 count = 0
      add_at = 0

C set all elements of 'order(:,:,5)' to 0
      i = 1
  809 j = 1
  810 order(i,j,5) = 0
      j = j + 1
      if (j .le. wall_c) goto 810
      i = i + 1
      if (i .le. wall_r) goto 809

      i = 1
  103 j = 1
C for each intersection of arr1 and arr2
  102 if ((arr1(i,j) .ne. '0') .and. (arr1(i,j) .eq. arr2(i,j)))
     +   goto 100
      goto 101
  100 is_sup = 0

C generate the number of matching candies for each direction
      k = 1
C if special candy is at the intersection, prevent treating
C different candies as the correct L/T matching
      if (wall(i,j) .eq. '@') goto 508
      goto 104
  508 wall(i,j) = arr1(i,j)
      add_at = 1
      is_sup = 1
  104 call travel(wall, wall_r, wall_c, swap, arr1, arr2, i, j, k, 0,
     +            cnt_d(k), spec, 0, super)
      arrsup(k) = super
      k = k + 1
      if (k .le. 4) goto 104
C add the '@' back
      if (add_at .eq. 1) goto 540
      goto 541
  540 wall(i,j) = '@'
  541 continue


C a matching can contain at most one special candy
      numsup = is_sup
      k = 1
  530 if (arrsup(k) .eq. 1) goto 531
      goto 534
  531 if (numsup .ge. 1) goto 533
      goto 532
  533 cnt_d(k) = 1
  532 numsup = numsup + 1
  534 k = k + 1
      if (k .le. 4) goto 530

C calculate the top-left most position
      if (cnt_d(2) .ge. 3) goto 520
      if (cnt_d(1) .ge. 3) goto 521
      iorder = i
      jorder = j
      goto 522
  520 iorder = i - cnt_d(2) + 1
      jorder = j
      goto 522
  521 iorder = i
      jorder = j - cnt_d(1) + 1
      goto 522
  522 continue

C early breaking when the position is occupied
      if (order(iorder,jorder,5) .eq. 0) goto 513
      goto 101

C calculate 'cnt_d(4)' for current position and store to 'order'
  513 k = 1
      count = 0
  110 order(iorder,jorder,k) = cnt_d(k)
      if (cnt_d(k) .ge. 3) goto 105
      goto 106
  105 count = count + 1
  106 k = k + 1
      if (k .le. 4) goto 110

C recognize whether it is a L/T or only an extended straight matching
      if (count .eq. 4) goto 108
      n_dir = 4
      goto 109
C if the only special candy in 'south' of a 'cross' matching, don't cut it
  108 if (numsup .eq. 1 .and. arrsup(4) .eq. 1) goto 545
      goto 546
  545 cnt_d(3) = 1
      order(iorder,jorder,3) = 1
      n_dir = 4
      goto 109
  546 n_dir = 3
      order(iorder,jorder,7) = 1
  109 if (count .le. 1) goto 101
      if (count .eq. 2 .and. ((cnt_d(1) .ge. 3 .and. cnt_d(3) .ge. 3)
     +    .or. (cnt_d(2) .ge. 3 .and. cnt_d(4) .ge. 3))) goto 101

C recognize whether it is a super matching
      l = 1
  510 if (arrsup(l) .eq. 1) goto 511
      goto 512
  511 is_sup = 1
  512 l = l + 1
      if (l .le. n_dir) goto 510
      if (s .eq. 1 .and. is_sup .eq. 0) goto 101

C store i,j to 'order'. if order(:,:,5) is non-zero, which means commit
C the L/T matching
      order(iorder,jorder,5) = i
      order(iorder,jorder,6) = j

  101 continue
      j = j + 1
      if (j .le. wall_c) goto 102
      i = i + 1
      if (i .le. wall_r) goto 103

C replace the top-left most L/T matching in the wall
      i = 1
  500 j = 1
  501 if (order(i,j,5) .ne. 0) goto 502
      goto 503
  502 k = 1
      if (order(i,j,7) .eq. 1) goto 505
      n_dir = 4
      goto 504
  505 n_dir = 3
  504 i_copy = order(i,j,5)
      j_copy = order(i,j,6)
      if (order(i,j,k) .ge. 3) goto 506
      goto 507
  506 call travel(wall, wall_r, wall_c, swap, arr1, arr2, i_copy,
     +            j_copy, k, 2, cnt_d(k), spec, 0, super)
  507 k = k + 1
      if (k .le. n_dir) goto 504
C store a '2' to 'spec', change the special candy in the wall to '0' to
C prevent super staight matching in the same stage, add it back later
      if (spec(order(i,j,5),order(i,j,6)) .eq. 2) goto 564
      spec(order(i,j,5),order(i,j,6)) = 2
      goto 565
  564 spec(order(i,j,5),order(i,j,6)) = 0
  565 wall(order(i,j,5),order(i,j,6)) = '0'

C algorithm sucks, go back and do again, wasting time
      goto 523

  503 j = j + 1
      if (j .le. wall_c) goto 501
      i = i + 1
      if (i .le. wall_r) goto 500
      end


C crush the special candies being matched
      subroutine c_spec(wall, wall_r, wall_c, spec, spec0)
      character wall(100,80)
      integer wall_r, wall_c, spec(100,80), spec0(100,80)
      i = 1
  600 j = 1
  601 if (spec0(i,j) .ne. 0 .and. spec0(i,j) .ne. spec(i,j)) goto 602
      goto 603
  602 if (spec0(i,j) .eq. 1) goto 604
      goto 605
  604 k = 1
  606 wall(i,k) = 'O'
      k = k + 1
      if (k .le. wall_c) goto 606
  605 if (spec0(i,j) .eq. 2) goto 607
      goto 603
  607 m = i - 1
      k = 1
  609 n = j - 1
      l = 1
  610 if (m .lt. 1 .or. m .gt. wall_r .or. n .lt. 1 .or. n .gt. wall_c)
     +   goto 611
      wall(m,n) = 'O'
  611 n = n + 1
      l = l + 1
      if (l .le. 3) goto 610
      m = m + 1
      k = k + 1
      if (k .le. 3) goto 609
  603 j = j + 1
      if (j .le. wall_c) goto 601
      i = i + 1
      if (i .le. wall_r) goto 600
      end


C add back the special candies generated to the wall
      subroutine g_spec(wall, wall_r, wall_c, spec)
      character wall(100,80)
      integer wall_r, wall_c, spec(100,80)
      i = 1
  550 j = 1
  551 if (spec(i,j) .eq. 1) goto 552
      if (spec(i,j) .eq. 2) goto 554
      goto 553
  552 wall(i,j) = '#'
      goto 553
  554 wall(i,j) = '@'
  553 j = j + 1
      if (j .le. wall_c) goto 551
      i = i + 1
      if (i .le. wall_r) goto 550
      end


C array traversal utility function
C mode = 0: check number of same canidies in particular direction
C mode = 1: produce arr1 and arr2
C mode = 2: replace candies in particular direction
C mode = 3: find all straight matches
C dir: traval direction, '1' is west, '2' is north, '3' is east,
C      '4' is south
C lastch: last character
C starti: starting index
C increx, increy: for loop increment for different traval direction
C lbound, ubound: lower bound and upper bound for crushing candies
C length: length which consider as a long enough matching
C s_tog: super matching toggle
C super: indicate whether include special candies during matching
      subroutine travel(wall, wall_r, wall_c, swap, arr1, arr2, startx,
     +                  starty, dir, mode, count, spec, s, super)
      character wall(100,80), arr1(100,80), arr2(100,80), lastch
      integer wall_r, wall_c, swap(2,2), startx, starty, dir, mode,
     +        count, starti, increx, increy, lbound, ubound, length,
     +        spec(100,80), s, s_tog, super

      length = 3
      super = 0

C determine increx, increy for different mode
      if (mode .eq. 0) goto 90
      if (mode .eq. 2) goto 120
      increx = 1
      increy = 1
      goto 91
  120 length = 2
   90 if (dir .eq. 1) goto 70
      if (dir .eq. 2) goto 71
      if (dir .eq. 3) goto 72
      if (dir .eq. 4) goto 73
   70 increx = wall_r
      increy = -1
      goto 75
   71 increx = -1
      increy = wall_c
      goto 76
   72 increx = wall_r
      increy = 1
      goto 75
   73 increx = 1
      increy = wall_c
      goto 76
   91 continue

C main traversal loop

C check vertically
C if mode = 2, exclude the center candy
   76 if (mode .eq. 2) goto 118
      goto 119
  118 startx = startx + increx
  119 i = starty
   83 count = 1
      s_tog = 0
      lastch = '0'
      starti = startx
      j = startx
   84 if (s_tog .eq. 0 .and. (wall(j,i) .eq. '@' .or.
     +    wall(j,i) .eq. '#')) goto 310
C early termination to prevent the 'fake L/T matching' problem
      if (mode .eq. 0 .and. wall(j,i) .ne. arr2(j,i)) goto 89
      goto 311
  310 s_tog = 1
      j = j + increx
      if (wall(j,i) .eq. lastch) goto 85
      if (count .lt. length) goto 341
      goto 355
  341 count = 2
      lastch = '0'
      starti = j - increx
  311 if (lastch .eq. '0') goto 352
      goto 353
  352 lastch = wall(j,i)
  353 j = j + increx
  355 if (lastch .lt. '1' .or. lastch .gt. '9') goto 87
      if (wall(j,i) .eq. lastch .or. s_tog .eq. 0 .and.
     +    (wall(j,i) .eq. '#' .or. wall(j,i) .eq. '@')) goto 85
      if (count .ge. length) goto 86
C when mode = 0, if that direction does not form a matching, return
      if (mode .eq. 0) goto 89
      goto 87
   86 if (s_tog .eq. 1 .and. super .eq. 0) goto 420
      goto 421
  420 super = 1
  421 if (mode .eq. 0) goto 89
C when s = 1, if it is not a super matching, break
      if (s .eq. 1 .and. s_tog .eq. 0) goto 87
      lbound = min(starti,starti+(count-1)*increx)
      ubound = max(starti,starti+(count-1)*increx)

C clear the special candies being crushed, when in replace modes
      if (mode .eq. 2 .or. mode .eq. 3) goto 422
      goto 423
C   422 spec(lbound:ubound,i) = 0
  422 jj = lbound
C if special candies connect the start of two straight matching,
C commit the horizontal one
      if (mode .eq. 3 .and. arr1(jj,i) .ne. '0' .and.
     +    arr1(jj,i) .ne. arr2(jj,i)) goto 87
  913 spec(jj,i) = 0
      jj = jj + 1
      if (jj .le. ubound) goto 913
  423 if ((mode .eq. 2) .or. (mode .eq. 3)) goto 115
C       arr2(lbound:ubound,i) = lastch
      jj = lbound
  914 arr2(jj,i) = lastch
      jj = jj + 1
      if (jj .le. ubound) goto 914
      goto 87
C   115 wall(lbound:ubound,i) = '|'
  115 jj = lbound
  915 wall(jj,i) = '|'
      jj = jj + 1
      if (jj .le. ubound) goto 915
      if (mode .eq. 2) goto 89

C calculate the position of special candy being created
      if (mode .eq. 3 .and. count .ge. 4) goto 123
      goto 87
  123 if (spec(ubound,i) .eq. 1) goto 562
      spec(ubound,i) = 1
      goto 563
  562 spec(ubound,i) = 0
  563 wall(ubound,i) = '0'

   87 count = 1
      s_tog = 0
      lastch = '0'
      starti = j
      goto 88
   85 count = count + 1
   88 if ((j .ge. 1) .and. (j .le. wall_r)) goto 84
      i = i + increy
      if ((i .ge. 1) .and. (i .le. wall_c)) goto 83


C when mode = 2, return because we only check one specific direction
      if (mode .eq. 2) goto 89


C check horizontally
C if mode = 2, exclude the center candy
   75 if (mode .eq. 2) goto 116
      goto 117
  116 starty = starty + increy
  117 i = startx
   77 count = 1
      s_tog = 0
      lastch = '0'
      starti = starty
      j = starty
   78 if (s_tog .eq. 0 .and. (wall(i,j) .eq. '@' .or.
     +    wall(i,j) .eq. '#')) goto 300
C early termination to prevent the 'fake L/T matching' problem
      if (mode .eq. 0 .and. wall(i,j) .ne. arr1(i,j)) goto 89
      goto 301
  300 s_tog = 1
      j = j + increy
      if (wall(i,j) .eq. lastch) goto 79
      if (count .lt. length) goto 340
      goto 354
  340 count = 2
      lastch = '0'
      starti = j - increy
  301 if (lastch .eq. '0') goto 350
      goto 351
  350 lastch = wall(i,j)
  351 j = j + increy
  354 if (lastch .lt. '1' .or. lastch .gt. '9') goto 82
      if (wall(i,j) .eq. lastch .or. s_tog .eq. 0 .and.
     +    (wall(i,j) .eq. '#' .or. wall(i,j) .eq. '@')) goto 79
      if (count .ge. length) goto 81
C when mode = 0, if that direction does not form a matching, return
      if (mode .eq. 0) goto 89
      goto 82
   81 if (s_tog .eq. 1 .and. super .eq. 0) goto 410
      goto 411
  410 super = 1
  411 if (mode .eq. 0) goto 89
C when s = 1, if it is not a super matching, break
      if (s .eq. 1 .and. s_tog .eq. 0) goto 82
      lbound = min(starti,starti+(count-1)*increy)
      ubound = max(starti,starti+(count-1)*increy)

C clear the special candies being crushed, except when in replace modes
      if (mode .eq. 2 .or. mode .eq. 3) goto 412
      goto 413
C   412 spec(i,lbound:ubound) = 0
  412 jj = lbound
  910 spec(i,jj) = 0
      jj = jj + 1
      if (jj .le. ubound) goto 910
  413 if ((mode .eq. 2) .or. (mode .eq. 3)) goto 114
C       arr1(i,lbound:ubound) = lastch
      jj = lbound
  911 arr1(i,jj) = lastch
      jj = jj + 1
      if (jj .le. ubound) goto 911
      goto 82
C   114 wall(i,lbound:ubound) = '-'
  114 jj = lbound
  912 wall(i,jj) = '-'
      jj = jj + 1
      if (jj .le. ubound) goto 912
      if (mode .eq. 2) goto 89

C calculate the position of special candy being created
      if (mode .eq. 3 .and. count .ge. 4) goto 121
      goto 82
  121 if ((i .eq. swap(1,1) .and. starti .eq. swap(1,2)) .or.
     +    (i .eq. swap(2,1) .and. starti .eq. swap(2,2))) goto 122
      spec(i,int((lbound+ubound)/2.0)) = 1
      wall(i,int((lbound+ubound)/2.0)) = '0'
      goto 82
  122 if (spec(i,starti) .eq. 1) goto 560
      spec(i,starti) = 1
      goto 561
  560 spec(i,starti) = 0
  561 wall(i,starti) = '0'

   82 count = 1
      s_tog = 0
      lastch = '0'
      starti = j
      goto 80
   79 count = count + 1
   80 if ((j .ge. 1) .and. (j .le. wall_c)) goto 78
      i = i + increx
      if ((i .ge. 1) .and. (i .le. wall_r)) goto 77

   89 end


C fortran 90's len_trim function
      integer function lentrm(input)
      character*(*) input
      lentrm = index(input, ' ') - 1
      end


C count number of digits of a number
      integer function numdig(number)
      integer number
      numdig = 0
 1031 if (number .gt. 0) goto 1030
      goto 1032
 1030 numdig = numdig + 1
      number = number / 10
      goto 1031
 1032 end
