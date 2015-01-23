(define write-to-file
  (lambda (roster)
    (display "\tEnter file name : ")
    (call-with-output-file (read-line)
      (lambda (output-port)
        (display roster output-port)))
  )
)

(define read-from-file
  (lambda ()
    (display "\tEnter file name : ")
    (define roster (call-with-input-file (read-line) read))
    (append roster '())
  )
)


(define (sort-by-grade L) 
   (cond ( (null? L) '() )
         ( else (cons (small-grade L (car L))
                      (sort-by-grade (remove L (small-grade L (car L)))))
         )
   )
)

(define (small-grade L A)
  (cond ( (null? L) A)
        ( (< (list-ref (car L) 2) (list-ref A 2)) (small-grade (cdr L)(car L)))
        (else (small-grade (cdr L) A ))
  )
)

(define (disp-sort-by-grade l)
  (disp-rost (sort-by-grade l) 1)
)

(define (sort-by-id L) 
   (cond ( (null? L) '() )
         ( else (cons (small-id L (car L))
                      (sort-by-id (remove L (small-id L (car L)))))
         )
   )
)

(define (small-id L A)
  (cond ( (null? L) A)
        ( (< (car (car L)) (car A)) (small-id (cdr L)(car L)))
        (else (small-id (cdr L) A ))
  )
)

(define (disp-sort-by-id l)
  (disp-rost (sort-by-id l) 1)
)

(define (sort-by-name L) 
   (cond ( (null? L) '() )
         ( else (cons (small-name L (car L))
                      (sort-by-name (remove L (small-name L (car L)))))
         )
   )
)

(define (small-name L A)
  (cond ( (null? L) A)
        ( (string<? (string (cadr (car L))) (string (cadr A))) (small-name (cdr L)(car L)))
        (else (small-name (cdr L) A ))
  )
)

(define (disp-sort-by-name l)
  (disp-rost (sort-by-name l) 1)
)

(define (remove L A)
  (cond ( (null? L) '() )           
        ( (eq? (car L) A) (cdr L))
        (else (cons (car L)(remove (cdr L) A)))
  )
)

(define disp-stud-info
  (lambda (roster sel curr len n)
    (cond ((= n 0) (begin
                      (display "\tEnter student name or ID : ")
                      (disp-stud-info roster (read-line) curr len 1)
                    ))
          ((= n 1) (begin
                      (if (> (length roster) 0)
                        (if (or (eq? (string->number sel) (car (car roster)))
                                (string=? sel (string (cadr (car roster))))
                            )
                          (begin
                            (display "\tID=")
                            (display
                              (list-ref (car roster) 0))
                            (display ", Name=\"")
                            (display
                              (list-ref (car roster) 1))
                            (display "\", Grade=")
                            (display
                              (list-ref (car roster) 2))
                            (disp-stud-info (cdr roster) sel (+ curr 1) len 2)
                          )
                          (disp-stud-info (cdr roster) sel (+ curr 1) len n) 
                        )
                        (begin
                          (display "\tStudent ")
                          (display sel)
                          (display " is not in the roster\n")
                        )
                      )
                    ))
          ((= n 2) (begin (newline)))
    )
  )
)

(define remove-from-roster
  (lambda (roster orig sel curr len n)
    (cond ((= n 0) (begin
                      (display "\tEnter student name or ID : ")
                      (remove-from-roster roster orig (read-line) curr len 1)
                    ))
          ((= n 1) (begin
                      (if (> (length roster) 0)
                        (if (or (eq? (string->number sel) (car (car roster)))
                                (string=? sel (string (cadr (car roster))))
                            )
                          (begin
                            (display "\tStudent ")
                            (display sel)
                            (display " removed.")
                            (remove-from-roster (remove orig (car roster)) orig sel (+ curr 1) len 2)
                          )
                          (remove-from-roster (cdr roster) orig sel (+ curr 1) len n) 
                        )
                        (begin
                          (display "\tStudent ")
                          (display sel)
                          (display " is not in the roster\n")
                        )
                      )
                    ))
          ((= n 2) (begin (append roster '())))
    )
  )
)

(define ano-read-3-items
  (lambda (n l roster orig)
     (cond ((= n 0) (begin
                      (display "\tStudent ID : ")
                      (ano-read-3-items 1 (list (string->number (read-line))) roster orig)
                     ))
           ((= n 1) (begin
                      (display "\tStudent Name : ")
                      (ano-read-3-items 2 (append l (list (read-line))) roster orig)
                     ))
           ((= n 2) (begin
                      (display "\tGrade : ")
                      (ano-read-3-items 3 (append l (list (string->number (read-line)))) roster orig)
                     ))
            ((= n 3) (begin
                        (if (> (length roster) 0)
                          (if (or (eq? (car l) (car (car roster)))
                                  (string=? (string (cadr l)) (string (cadr (car roster))))
                              )
                            (begin
                              (display "\tStudent (ID:")
                              (display
                                (list-ref l 0))
                              (display ") is already on the roster.\n")
                              (ano-read-3-items 5 l roster orig)
                            )
                            (ano-read-3-items n l (cdr roster) orig)
                          )
                          (ano-read-3-items 4 l roster orig)
                        )
                      ))
           ((= n 4) (begin
                      (display "\tStudent (ID:")
                      (display
                        (list-ref l 0))
                      (display ") inserted.\n\n")
                      (cons l orig)
                     ))
           ((= n 5) (begin (append orig '())))
      )
  )
)

(define disp-rost
  (lambda (roster curr)
    (if (> (length roster) 0)
      (begin
        (display "\tNo.")
        (display curr)
        (display ": ID=")
        (display
          (list-ref (car roster) 0))
        (display ", Name=\"")
        (display
          (list-ref (car roster) 1))
        (display "\", Grade=")
        (display
          (list-ref (car roster) 2))
        (display "\n")
        (disp-rost (cdr roster) (+ curr 1))
      )
    )
  )
) 

(define performtask
  (lambda (n roster) 
    (cond ((= n 0) (begin
                    (display "\n\tReset Roster.\n\n")
                    (menu '())
                    ))
          ((= n 1) (begin
                    (display "\n\tLoad roster from a file:\n\n")
                    (newline)
                    (menu (read-from-file))
                    ))
          ((= n 2) (begin
                    (display "\n\tStore roster to a file:\n\n")
                    (write-to-file roster)
                    (newline)
                    (menu roster)
                    ))
          ((= n 3) (begin
                    (display "\n\tDisplay roster sorted by ID:\n\n")
                    (disp-sort-by-id roster)
                    (newline)
                    (menu roster)
                    ))
          ((= n 4) (begin
                    (display "\n\tDisplay roster sorted by name:\n\n")
                    (disp-sort-by-name roster)
                    (newline)
                    (menu roster)
                    ))
          ((= n 5) (begin
                    (display "\n\tDisplay roster sorted by grade:\n\n")
                    (disp-sort-by-grade roster)
                    (newline)
                    (menu roster)
                    ))
          ((= n 6) (begin
                    (display "\n\tDisplay student info\n\n")
                    (disp-stud-info roster 0 1 (length roster) 0)
                    (newline)
                    (menu roster)
                    ))
          ((= n 7) (begin
                    (display "\n\tAdd a student to the class roster\n\n")
                    (newline)
                    (menu (ano-read-3-items 0 '() roster roster))
                    ))
          ((= n 8) (begin
                    (display "\n\tRemove a student from roster\n\n")
                    (newline)
                    (menu (remove-from-roster roster roster 0 1 (length roster) 0))
                    ))
          ((= n 9) (begin
                    (display "\n\tExit\n")
                    #t
                    ))
           (else (begin
                    (display "\n\ttask no. ")
                    (display n)
                    (display " does not exist.\n\n")
                    (menu roster)
                  )
            )
     )
   )
)

(define menu
  (lambda (roster)
     (begin
        (newline)
        (newline)
        (display "\tClass roster management system\n")
        (display "\t============================\n")
        (display "\t   MENU\n")
        (display "\t============================\n")
        (display "\t0. Reset Roster\n")
        (display "\t1. Load roster from a file\n")
        (display "\t2. Store roster to a file\n")
        (display "\t3. Display roster sorted by ID\n")
        (display "\t4. Display roster sorted by name\n")
        (display "\t5. Display roster sorted by grade\n")
        (display "\t6. Display student info\n")
        (display "\t7. Add a student to roster\n")
        (display "\t8. Remove a student from roster\n")
        (display "\t9. Exit\n\n")
        (display "\tEnter your choice: ")
        (performtask (read) roster)
      )
   )
)


(menu '())