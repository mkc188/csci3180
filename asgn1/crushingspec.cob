       identification division.
       program-id. crushing.

      * CSCI3180 Principles of Programming Languages

      * --- Declaration ---

      * I declare that the assignment here submitted is original except for source
      * material explicitly acknowledged. I also acknowledge that I am aware of
      * University policy and regulations on honesty in academic work, and of the
      * disciplinary guidelines and procedures applicable to breaches of such policy
      * and regulations, as contained in the website
      * http://www.cuhk.edu.hk/policy/academichonesty/

      * Assignment 1

       environment division.
       input-output section.
       file-control.
           select infile assign to 'input.txt'
               organization is line sequential
               status is in-status.
           select outfile assign to outfile-name
               organization is line sequential.

       data division.
       file section.

       fd infile.

       01 a-line pic x(80).

       fd outfile.

       01 out-line.
           03 out-char pic X occurs 1 to 80 depending on wall-c.
       01 out-jimmy.
           03 jim-char pic X occurs 15 to 25 depending on jim-len.

       working-storage section.

       01 in-status pic 9(2).
       01 error-message pic x(78).

       01 open-failed-message pic x(78) value 'error: No such file'.
       01 wrong-coor-message pic x(78) value 'error: Wrong coordinates'.

       01 roof-r pic 9(3).
       01 roof-c pic 9(2).
       01 wall-r pic 9(3).
       01 wall-c pic 9(2).
       01 swap-table.
          03 swap-row occurs 2.
             05 swap  occurs 2 pic 9(3).
       01 total-score pic 9(5).
       01 current-score pic 9(5).
       01 roof-index-table.
          03 roof-index occurs 80 pic 9(3).
       01 score pic 9(5) value 0.
       01 spec-table.
          03 spec-row occurs 100.
             05 spec occurs 80 pic 9.
       01 spec0-table.
          03 spec0-row occurs 100.
             05 spec0 occurs 80 pic 9.
       01 cont pic 9.
       01 roof-table.
          03 roof-row occurs 100.
             05 roof occurs 80 pic X.
       01 wall-table.
          03 wall-row occurs 100.
             05 wall occurs 80 pic X.
       01 arr1-table.
          03 arr1-row occurs 100.
             05 arr1 occurs 80 pic X value '0'.
       01 arr2-table.
          03 arr2-row occurs 100.
             05 arr2 occurs 80 pic X value '0'.
       01 str pic X(5).
       01 candy-buffer-table.
          03 candy-buffer occurs 100 pic X.
       01 tmp-char pic X.
       01 tmp-row.
          03 tmp-row-char occurs 1 to 80 depending on wall-c pic X.
       01 tmp-i pic 9(3).
       01 next-candy pic X.
       01 row-index pic 9(3).
       01 startx pic 9(3).
       01 starty pic 9(3).
       01 dir pic 9.
       01 travel-mode pic 9.
       01 candy-count pic 9(3).
       01 s pic 9.
       01 include-super pic 9.
       01 count-dir-table.
          03 count-dir occurs 4 pic 9(3).
       01 number-dir pic 9.
       01 array-super-table.
          03 array-super occurs 4 pic 9(3).
       01 order-table.
          03 order-d1 occurs 100.
             05 order-d2 occurs 80.
                07 order-d3 occurs 7 pic 9(3).
       01 add-at pic 9.
       01 is-sup pic 9.
       01 num-sup pic 9.
       01 iorder pic 9(3).
       01 jorder pic 9(3).
       01 i-copy pic 9(3).
       01 j-copy pic 9(3).
       01 candy-length pic 9(3).
       01 super-toggle pic 9.
       01 last-char pic X.
       01 lower-bound pic 9(3).
       01 upper-bound pic 9(3).
       01 starti pic 9(3).
       01 increx pic S9(3).
       01 increy pic S9(3).
       01 outfile-name pic X(13) value spaces.
       01 win pic 9.
       01 jim-len pic 9(2) value 25.

       01 i pic 9(3).
       01 j pic 9(3).
       01 k pic 9(3).
       01 l pic 9(3).
       01 m pic 9(3).
       01 n pic 9(3).
       01 i0 pic 9(3).
       01 j0 pic 9(3).
       01 k0 pic 9(3).
       01 l0 pic 9(3).
       01 m0 pic 9(3).
       01 n0 pic 9(3).

       01 ibackup pic 9(3).
       01 jbackup pic 9(3).
       01 kbackup pic 9(3).

       01 iterator-i-bool pic X.
          88 iterator-i-next value 'Y'.
       01 iterator-k-bool pic X.
          88 iterator-k-next value 'Y'.
       01 iterator-i0-bool pic X.
          88 iterator-i0-next value 'Y'.
       01 iterator-ij-bool pic X.
          88 iterator-ij-next value 'Y'.
       01 iterator-mn0-bool pic X.
          88 iterator-mn0-next value 'Y'.



       procedure division.

       main-paragraph.
      * open input file
           open input infile
           if in-status not = 0 then
               move open-failed-message to error-message
               perform error-termination
           end-if

      * read constant value from input file
           perform read-constant

      * check if the swapping is valid
           perform validate-swapping

      * read candies into roof
           perform read-roof thru read-roof-exit

      * initialize roof column index
           move roof-c to i0
           perform iterator-i-init.
       loop-init-roof-index.
           move roof-r to roof-index(i)
           perform iterator-i
           if (iterator-i-next) go to loop-init-roof-index end-if.

      * initialize wall
           move wall-c to j0
           move wall-r to i0
           perform iterator-ij-init.
       loop-init-wall.
           move '0' to wall(i,j)
           perform iterator-ij
           if (iterator-ij-next) go to loop-init-wall end-if.

      * load candies from roof to wall
           perform load-candy thru load-candy-exit

      * perform swapping
           perform go-swap

      * main loop
           move 0 to score.
       main-loop.
           display 'wall A:'
           perform print-wall thru print-wall-exit
           perform scan-spec thru scan-spec-exit
           perform find-arr12 thru find-arr12-exit
           display 'arr1:'
           perform print-arr1 thru print-arr1-exit
           display 'arr2:'
           perform print-arr2 thru print-arr2-exit
           move 1 to s
           perform find-lt thru find-lt-exit
           perform find-straight thru find-straight-exit
           move 0 to s
           perform find-lt thru find-lt-exit
           perform find-straight thru find-straight-exit
           display 'wall B:'
           perform print-wall thru print-wall-exit
           perform generate-spec thru generate-spec-exit
           perform crush-spec thru crush-spec-exit
           display 'wall C:'
           perform print-wall thru print-wall-exit
           perform load-candy thru load-candy-exit
           add current-score to score
           display 'score: ' score
           perform result thru result-exit
           if (cont = 1) go to main-loop end-if.

           close infile

           goback.






       read-constant.
           read infile end-read
           unstring a-line delimited by space
               into roof-r roof-c
           end-unstring
           read infile end-read
           unstring a-line delimited by space
               into wall-r wall-c
           end-unstring
           read infile end-read
           unstring a-line delimited by space
               into swap(1,1) swap(1,2) swap(2,1) swap(2,2)
           end-unstring
           read infile end-read
           unstring a-line delimited by space
               into total-score
           end-unstring.

       error-termination.
           display error-message
           close infile
           stop run.

       validate-swapping.
           if (swap(1,1) < 1 or swap(1,1) > wall-r or
               swap(2,1) < 1 or swap(2,1) > wall-r or
               swap(1,2) < 1 or swap(1,2) > wall-c or
               swap(2,2) < 1 or swap(2,2) > wall-c)
               move wrong-coor-message to error-message
               perform error-termination end-if.

       read-roof.
           move roof-r to i0
           perform iterator-i-init.
       loop-read-roof.
           read infile end-read
           move a-line to roof-row(i)
           perform iterator-i
           if (iterator-i-next) go to loop-read-roof end-if.
       read-roof-exit.


       iterator-ij-init.
           move 1 to i
           move 1 to j
           move 'N' to iterator-ij-bool.
       iterator-ij.
           add 1 to j
           if (j > j0)
               move 1 to j
               add 1 to i
           end-if
           evaluate i
               when 1 thru i0 move 'Y' to iterator-ij-bool
               when other move 'N' to iterator-ij-bool
           end-evaluate.


       iterator-i-init.
           move 1 to i
           move 'N' to iterator-i-bool.
       iterator-i.
           add 1 to i
           evaluate i
               when 1 thru i0 move 'Y' to iterator-i-bool
               when other move 'N' to iterator-i-bool
           end-evaluate.


       iterator-i0-init.
           move i0 to i
           move 'N' to iterator-i0-bool.
       iterator-i0.
           subtract 1 from i
           evaluate i
               when 1 thru i0 move 'Y' to iterator-i-bool
               when other move 'N' to iterator-i-bool
           end-evaluate.

       iterator-k-init.
           move 1 to k
           move 'N' to iterator-k-bool.
       iterator-k.
           add 1 to k
           evaluate k
               when 1 thru k0 move 'Y' to iterator-k-bool
               when other move 'N' to iterator-k-bool
           end-evaluate.


       iterator-mn0-init.
           move 1 to m
           move n0 to n
           move 'N' to iterator-mn0-bool.
       iterator-mn0.
           subtract 1 from n
           if (n < 1)
               move n0 to n
               add 1 to m
           end-if
           evaluate m
               when 1 thru m0 move 'Y' to iterator-mn0-bool
               when other move 'N' to iterator-mn0-bool
           end-evaluate.



       load-candy.
           move zeros to candy-buffer-table
           move 0 to current-score
           move wall-c to m0
           move wall-r to n0
           perform iterator-mn0-init
           move 1 to l.
       loop-load-candy.
           move wall(n,m) to tmp-char
           evaluate tmp-char
               when '1' thru '9'
               when '@'
               when '#'
                  move tmp-char to candy-buffer(l)
                  add 1 to l
               when other add 1 to current-score
           end-evaluate
           subtract 1 from n
           if (n >= 1) go to loop-load-candy end-if.
       load-candy-2.
           move wall-r to i0
           perform iterator-i0-init.
       loop-load-candy-2.
           compute tmp-i = wall-r - i + 1
           move candy-buffer(tmp-i) to wall(i,m)
           perform iterator-i0
           if (iterator-i0-next) go to loop-load-candy-2 end-if.
           move zeros to candy-buffer-table
           add 1 to m
           if (m <= wall-c)
               move 1 to l
               move wall-r to n
               go to loop-load-candy
           end-if
           move wall-c to m0
           move wall-r to n0
           perform iterator-mn0-init.
       loop-load-candy-3.
           if (wall(n,m) = '0')
               perform load-next-candy
               move next-candy to wall(n,m)
               perform iterator-mn0
           end-if
           if (iterator-mn0-next) go to loop-load-candy-3 end-if.
       load-candy-exit.


       load-next-candy.
           move roof-index(m) to row-index
           move roof(row-index, m) to next-candy
           subtract 1 from row-index
           evaluate row-index
               when 1 thru roof-r move row-index to roof-index(m)
               when other move roof-r to row-index
           end-evaluate.

       go-swap.
           move wall(swap(1,1),swap(1,2)) to tmp-char
           move wall(swap(2,1),swap(2,2)) to wall(swap(1,1),swap(1,2))
           move tmp-char to wall(swap(2,1),swap(2,2)).

       print-wall.
           move wall-r to i0
           perform iterator-i-init.
       loop-print-wall.
           move wall-row(i) to tmp-row
           display tmp-row
           perform iterator-i
           if (iterator-i-next) go to loop-print-wall.
       print-wall-exit.


       print-arr1.
           move wall-r to i0
           perform iterator-i-init.
       loop-print-arr1.
           move arr1-row(i) to tmp-row
           display tmp-row
           perform iterator-i
           if (iterator-i-next) go to loop-print-arr1.
       print-arr1-exit.


       print-arr2.
           move wall-r to i0
           perform iterator-i-init.
       loop-print-arr2.
           move arr2-row(i) to tmp-row
           display tmp-row
           perform iterator-i
           if (iterator-i-next) go to loop-print-arr2.
       print-arr2-exit.



       scan-spec.
           move zeros to spec-table spec0-table
           move wall-r to i0
           move wall-c to j0
           perform iterator-ij-init.
       loop-scan-spec.
           evaluate wall(i,j)
               when '#' move 1 to spec(i,j) spec0(i,j)
               when '@' move 2 to spec(i,j) spec0(i,j)
           end-evaluate
           perform iterator-ij
           if (iterator-ij-next) go to loop-scan-spec end-if.
       scan-spec-exit.


       find-arr12.
           move zeros to arr1-table arr2-table
           move 1 to startx starty
           move 3 to dir
           move 1 to travel-mode
           move 0 to s
           display 'arr12'
           perform travel thru travel-exit.
       find-arr12-exit.


       find-straight.
           move 1 to startx starty
           move 3 to dir travel-mode
           perform travel thru travel-exit.
       find-straight-exit.


       find-lt.
           move 0 to candy-count add-at
           move zeros to order-table
           move wall-c to j0
           move wall-r to i0
           perform iterator-ij-init.
       loop-find-lt.
           if (arr1(i,j) = '0' or arr1(i,j) not = arr2(i,j))
               perform iterator-ij
               if (iterator-ij-next) go to loop-find-lt end-if
           end-if

               move 0 to is-sup
               move 4 to k0
               perform iterator-k-init.
       loop-find-lt-2.
               if (wall(i,j) = '@')
                     move arr1(i,j) to wall(i,j)
                     move 1 to add-at is-sup
               end-if
               move i to startx ibackup
               move j to starty jbackup
               move k to dir kbackup
               move 0 to travel-mode
               *> move count-dir(k) to candy-count
               *> move 0 to include-super
               perform travel thru travel-exit
               move ibackup to i
               move jbackup to j
               move kbackup to k
               move candy-count to count-dir(k)

               move include-super to array-super(k)
               perform iterator-k
               if (iterator-k-next) go to loop-find-lt-2 end-if.
       loop-find-lt-8.
      * add the '@' back
               if (add-at = 1) move '@' to wall(i,j) end-if

      * a matching can contain at most one special candy
               move is-sup to num-sup
               move 4 to k0
               perform iterator-k-init.
       loop-find-lt-3.
               if (array-super(k) = 1 and num-sup >= 1)
                     move 1 to count-dir(k)
               end-if
               if (array-super(k) = 1) add 1 to num-sup end-if
               perform iterator-k
               if (iterator-k-next) go to loop-find-lt-3 end-if.
       loop-find-lt-9.
      * calculate the top-left most position
               if (count-dir(2) >= 3)
                     compute tmp-i = i - count-dir(2) + 1
                     move tmp-i to iorder
                     move j to jorder
               end-if
               if (count-dir(1) >= 3)
                     move i to iorder
                     compute tmp-i = j - count-dir(1) + 1
                     move tmp-i to jorder
               end-if
               if (count-dir(2) < 3 and count-dir(1) < 3)
                     move i to iorder
                     move j to jorder
               end-if
      * early breaking when the position is occupied
               if (order-d3(iorder,jorder,5) not = 0)
                     perform iterator-ij
                     if (iterator-ij-next) go to loop-find-lt end-if
               end-if
      * calculate 'count-dir' for current position
               move 4 to k0
               perform iterator-k-init
               move 0 to candy-count.
       loop-find-lt-4.

               move count-dir(k) to order-d3(iorder,jorder,k)
               if (count-dir(k) >= 3) add 1 to candy-count end-if
               perform iterator-k
               if (iterator-k-next) go to loop-find-lt-4 end-if.
      * recognize whether it is a L/T or only an extended straight
               move 4 to number-dir
               if (candy-count = 4 and num-sup = 1 and
                   array-super(4) = 1)
                     move 1 to count-dir(3)
                     move 1 to order-d3(iorder,jorder,3)
                     move 4 to number-dir
               end-if
               if (candy-count = 4)
                     move 3 to number-dir
                     move 1 to order-d3(iorder,jorder,7)
               end-if
               if (candy-count <= 1 or (candy-count = 2 and
                   ((count-dir(1) >= 3 and count-dir(3) >=3) or
                    (count-dir(2) >= 3 and count-dir(4) >=3))))
                     perform iterator-ij
                     if (iterator-ij-next) go to loop-find-lt end-if
               end-if

      * recognize whether it is a super matching
               move number-dir to k0
               perform iterator-k-init.
       loop-find-lt-5.
               if (array-super(k) = 1) move 1 to is-sup end-if
               display 'array-super(k) ' array-super(k)
               perform iterator-k
               if (iterator-k-next) go to loop-find-lt-5 end-if
               if (s = 1 and is-sup = 0)
                     perform iterator-ij
                     if (iterator-ij-next) go to loop-find-lt end-if
               end-if
      * store i,j to 'order'. if order(:,:,5) is non-zero,
      * which means commit the L/T matching
               move i to order-d3(iorder,jorder,5)
               move j to order-d3(iorder,jorder,6)

               perform iterator-ij
           if (iterator-ij-next) go to loop-find-lt end-if.


       loop-find-lt-10.
      * replace the top-left most L/T matching in the wall
           move wall-r to i0
           move wall-c to j0
           display 'end loop-find-lt-10'
           perform iterator-ij-init.
       loop-find-lt-6.
           if (order-d3(i,j,5) not = 0)
               display 'win win i: ' i ' j: ' j
               display 'numdir: ' number-dir
               display order-d3(i,j,1) order-d3(i,j,2) order-d3(i,j,3)
                  order-d3(i,j,4)
               move number-dir to k0
               perform iterator-k-init
               move 4 to number-dir
               if (order-d3(i,j,7) = 1) move 3 to number-dir end-if
               go to loop-find-lt-7
           end-if
           perform iterator-ij
           display 'end loop-find-lt-6 i: ' i ' j: ' j
           if (iterator-ij-next) go to loop-find-lt-6 end-if
           go to find-lt-exit.
       loop-find-lt-7.
               move order-d3(i,j,5) to i-copy
               move order-d3(i,j,6) to j-copy
               if (order-d3(i,j,k) >= 3)
                     move i-copy to startx
                     move j-copy to starty
                     move i to ibackup
                     move j to jbackup
                     move k to dir kbackup
                     move 2 to travel-mode
                     *> move count-dir(k) to candy-count
                     *> move 0 to include-super
                     display 'before: ' i-copy ' ' j-copy



                     display 'i: ' i ' j: ' j ' k: ' k
                      ' include-super: ' include-super
                      ' s: ' s ' super-toggle: ' super-toggle
                      ' increx: ' increx ' increy: ' increy
                      ' candy-length: ' candy-length
                      ' is-sup: ' is-sup




                     perform travel thru travel-exit
                     display 'after: ' i-copy ' ' j-copy
                     move ibackup to i
                     move jbackup to j
                     move kbackup to k
               end-if
               perform iterator-k
               display 'end loop-find-lt-7   k: ' k
               if (iterator-k-next) go to loop-find-lt-7 end-if.
       loop-find-lt-11.
      * store a '2' to 'spec', change the special candy to '0' to
      * prevent super staight matching in the same stage
           move 2 to spec(order-d3(i,j,5),order-d3(i,j,6))
           if (spec(order-d3(i,j,5),order-d3(i,j,6)) = 2)
               move 0 to spec(order-d3(i,j,5),order-d3(i,j,6))
           end-if
           move '0' to wall(order-d3(i,j,5),order-d3(i,j,6))

      * algorithm sucks, go back and do again, wasting time
            display 'end loop-find-lt-11'
           go to find-lt.
       find-lt-exit.

       travel.
           move 3 to candy-length
           move 0 to include-super

      * determine increx, increy for different mode
           move 1 to increx increy
           if (travel-mode = 2) move 2 to candy-length end-if
           if (travel-mode = 0 or travel-mode = 2)
               evaluate dir
                  when 1   move wall-r to increx
                           move -1 to increy
                           go to loop-travel-21
                  when 2   move -1 to increx
                           move wall-c to increy
                           go to loop-travel-20
                  when 3   move wall-r to increx
                           move 1 to increy
                           go to loop-travel-21
                  when 4   move 1 to increx
                           move wall-c to increy
                           go to loop-travel-20
               end-evaluate
           end-if.

      * main traversal loop

       loop-travel-20.
      * check vertically
      * if mode = 2, exclude the center candy
           if (travel-mode = 2) add increx to startx end-if
           move starty to i.
       loop-travel.
           move 1 to candy-count
           move 0 to super-toggle
           move '0' to last-char
           move startx to starti
           move startx to j.
       loop-travel-8.
           if (super-toggle = 0 and (wall(j,i) = '@' or
               wall(j,i) = '#'))
               move 1 to super-toggle
               display 'bingo'
               add increx to j
               if (wall(j,i) = last-char)
                  add 1 to candy-count
                  go to loop-travel-9
               end-if
               if (candy-count < candy-length)
                     move 2 to candy-count
                     move '0' to last-char
                     compute starti = j - increx
                     go to loop-travel-1
               end-if
               go to loop-travel-2
           end-if
      * early termination to prevent fake L/T matching
           if (travel-mode = 0 and wall(j,i) not = arr2(j,i))
               go to travel-exit
           end-if.
       loop-travel-1.
           if (last-char = '0')
               *> if (wall(j,i) = '')
               move wall(j,i) to last-char
           end-if
           add increx to j.
       loop-travel-2.
           if (last-char < '1' or last-char > '9')
               go to loop-travel-7
           end-if
           if (wall(j,i) = last-char or (super-toggle = 0 and
               (wall(j,i) = '#' or wall(j,i) = '@')))
               add 1 to candy-count
               go to loop-travel-9
           end-if
           if (candy-count >= candy-length and super-toggle = 1 and
               include-super = 0) move 1 to include-super end-if
      * when mode = 0, return if that direction does not form a matching
           if (travel-mode = 0) go to travel-exit end-if
           if (candy-count < candy-length) go to loop-travel-7 end-if
           if (travel-mode = 0) go to travel-exit end-if
      * when s = 1, if it is not a super matching, break
           if (s = 1 and super-toggle = 0) go to loop-travel-7 end-if
           compute tmp-i = starti + (candy-count - 1) * increx
           if (starti < tmp-i)
               move starti to lower-bound
               move tmp-i to upper-bound
           end-if
           if (starti >= tmp-i)
               move starti to upper-bound
               move tmp-i to lower-bound
           end-if
      * clear the special candies being crushing when in replace modes
           if (travel-mode = 2 or travel-mode = 3)
               move lower-bound to k
               go to loop-travel-3
           end-if
           move lower-bound to k
      * special case
           if (travel-mode = 3 and arr1(k,i) not = '0' and
               arr1(k,i) not = arr2(k,i)) go to loop-travel-7 end-if.
       loop-travel-5.
           move 0 to spec(k,i)
           add 1 to k
           if (k <= upper-bound) go to loop-travel-5 end-if
           move lower-bound to k.
       loop-travel-6.
           move last-char to arr2(k,i)
           add 1 to k
           if (k <= upper-bound) go to loop-travel-6 end-if
           go to loop-travel-7.
       loop-travel-3.
           move '|' to wall(k,i)
           display 'replaced |'
           add 1 to k
           if (k <= upper-bound) go to loop-travel-3 end-if.
       loop-travel-4.
           if (travel-mode = 2) go to travel-exit end-if
      * calculate the position of special candy being created
           if (travel-mode = 3 and candy-count >= 4)
               move 0 to spec(upper-bound,i)
               if (spec(upper-bound,i) = 1)
                  move 1 to spec(upper-bound,i)
               end-if
               move '0' to wall(upper-bound,i)
           end-if.
       loop-travel-7.
           move 1 to candy-count
           move 0 to super-toggle
           move '0' to last-char
           move j to starti.
       loop-travel-9.
           if (j >= 1 and j <= wall-r) go to loop-travel-8 end-if
           add increy to i
           if (i >= 1 and i <= wall-c) go to loop-travel end-if.
       loop-travel-10.
            display 'travel-mode: ' travel-mode
       if (travel-mode = 2) go to travel-exit end-if.


       loop-travel-21.
      * check horizontally

      * if mode = 2, exclude the center candy
           if (travel-mode = 2) add increy to starty end-if
           move startx to i.
       loop-travel-0.
           move 1 to candy-count
           move 0 to super-toggle
           move '0' to last-char
           move starty to starti
           move starty to j.
       loop-travel-18.
           if (super-toggle = 0 and (wall(i,j) = '@' or
               wall(i,j) = '#'))
               move 1 to super-toggle
               add increy to j
               if (wall(i,j) = last-char)
                  add 1 to candy-count
                  go to loop-travel-19
               end-if
               if (candy-count < candy-length)
                     move 2 to candy-count
                     move '0' to last-char
                     compute starti = j - increy
                     go to loop-travel-11
               end-if
               go to loop-travel-12
           end-if
      * early termination to prevent fake L/T matching
           if (travel-mode = 0 and wall(i,j) not = arr1(i,j))
               go to travel-exit
           end-if.
       loop-travel-11.
           if (last-char = '0')
               move wall(i,j) to last-char
           end-if
           add increy to j.
       loop-travel-12.
           if (last-char < '1' or last-char > '9')
               go to loop-travel-17
           end-if
           if (wall(i,j) = last-char or (super-toggle = 0 and
               (wall(i,j) = '#' or wall(i,j) = '@')))
               add 1 to candy-count
               go to loop-travel-19
           end-if
           if (candy-count >= candy-length and super-toggle = 1 and
               include-super = 0) move 1 to include-super end-if
      * when mode = 0, return if that direction does not form a matching
           if (travel-mode = 0) go to travel-exit end-if
           if (candy-count < candy-length) go to loop-travel-17 end-if
           if (travel-mode = 0) go to travel-exit end-if
      * when s = 1, if it is not a super matching, break
           if (s = 1 and super-toggle = 0) go to loop-travel-17 end-if
           compute tmp-i = starti + (candy-count - 1) * increy
           if (starti < tmp-i)
               move starti to lower-bound
               move tmp-i to upper-bound
           end-if
           if (starti >= tmp-i)
               move starti to upper-bound
               move tmp-i to lower-bound
           end-if
      * clear the special candies being crushing when in replace modes
           if (travel-mode = 2 or travel-mode = 3)
               move lower-bound to k
               go to loop-travel-13
           end-if
           move lower-bound to k.
       loop-travel-15.
           move 0 to spec(i,k)
           add 1 to k
           if (k <= upper-bound) go to loop-travel-15 end-if
           move lower-bound to k.
       loop-travel-16.
           move last-char to arr1(i,k)
           add 1 to k
           if (k <= upper-bound) go to loop-travel-16 end-if
           go to loop-travel-17.
       loop-travel-13.
           move '-' to wall(i,k)
           display 'replaced -'
           add 1 to k
           if (k <= upper-bound) go to loop-travel-13 end-if.
       loop-travel-14.
           if (travel-mode = 2) go to travel-exit end-if
      * calculate the position of special candy being created
           if (travel-mode = 3 and candy-count >= 4)
               if ((i = swap(1,1) and starti = swap(1,2)) or
                   (i = swap(2,1) and starti = swap(2,2)))
                  move 0 to spec(i,starti)
                  if (spec(i,starti) = 1)
                     move 0 to spec(i,starti)
                  end-if
                  move '0' to wall(i,starti)
               end-if
               if ((i not = swap(1,1) or starti not = swap(1,2)) and
                   (i not = swap(2,1) or starti not = swap(2,2)))
                  compute tmp-i = (lower-bound + upper-bound) / 2.0
                  move 1 to spec(i,tmp-i)
                  move '0' to wall(i,tmp-i)
               end-if
           end-if.
       loop-travel-17.
           move 1 to candy-count
           move 0 to super-toggle
           move '0' to last-char
           move j to starti.
       loop-travel-19.
           if (j >= 1 and j <= wall-c) go to loop-travel-18 end-if
           add increy to i
           if (i >= 1 and i <= wall-r) go to loop-travel-0 end-if.
       travel-exit.


       generate-spec.
           move wall-c to j0
           move wall-r to i0
           perform iterator-ij-init.
       loop-generate-spec.
           if (spec(i,j) = 1) move '#' to wall(i,j) end-if
           if (spec(i,j) = 2) move '@' to wall(i,j) end-if
           perform iterator-ij
           if (iterator-ij-next) go to loop-generate-spec end-if.
       generate-spec-exit.


       crush-spec.
           move wall-c to j0
           move wall-r to i0
           perform iterator-ij-init.
       loop-crush-spec.
           if (spec0(i,j) not = 0 and spec0(i,j) not = spec(i,j))
               go to loop-crush-spec-602
           end-if
           go to loop-crush-spec-603.
       loop-crush-spec-602.
           if (spec0(i,j) = 1) go to loop-crush-spec-604 end-if
           go to loop-crush-spec-605.
       loop-crush-spec-604.
           move 1 to k.
       loop-crush-spec-606.
           move 'O' to wall(i,k)
           add 1 to k
           if (k <= wall-c) go to loop-crush-spec-606 end-if.
       loop-crush-spec-605.
           if (spec0(i,j) = 2) go to loop-crush-spec-607 end-if
           go to loop-crush-spec-603.
       loop-crush-spec-607.
           compute m = i - 1
           move 1 to k.
       loop-crush-spec-609.
           compute n = j - 1
           move 1 to l.
       loop-crush-spec-610.
           if (m < 1 or m > wall-r or n < 1 or n > wall-c)
               go to loop-crush-spec-611
           end-if
           move 'O' to wall(m,n).
       loop-crush-spec-611.
           add 1 to n
           add 1 to l
           if (l <= 3) go to loop-crush-spec-610
           add 1 to m
           add 1 to k
           if (k <= 3) go to loop-crush-spec-609.
       loop-crush-spec-603.
           perform iterator-ij
           if (iterator-ij-next) go to loop-crush-spec.
       crush-spec-exit.


       result.
           move 0 to cont
           if (score >= total-score) go to loop-result-801 end-if
           if (current-score = 0) go to loop-result-803 end-if
           move 1 to cont
           go to result-exit.
       loop-result-801.
           move 1 to win
           go to loop-result-811.
       loop-result-803.
           move 0 to win.
       loop-result-811.
           string 'cob' delimited by size
                  total-score delimited by space
                  '.txt' delimited by size into outfile-name


           open output outfile
           move wall-r to i0
           perform iterator-i-init.
       loop-result.
           move wall-row(i)(1:wall-c) to out-line
           write out-line
           perform iterator-i
           if (iterator-i-next) go to loop-result end-if.
       loop-result-2.
           if (win = 1)
               move 'Jimmy is locked forver!' to out-jimmy
               move 24 to jim-len
           end-if
           if (win = 0)
               move 'Jimmy is safe!' to out-jimmy
           end-if
           write out-jimmy
           close outfile.
       result-exit.
