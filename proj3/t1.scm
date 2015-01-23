(define performtask
  (lambda (n roster) 
    (cond ((= n 0) (begin
                    (display "\n\tOption 0.\n")
                    (menu '())
                    ))
          ((= n 1) (begin
                    (display "\n\tOption 1.\n")
                    (menu roster)
                    ))
          ((= n 2) (begin
                    (display "\n\tOption 2. Exit\n")
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
        (display "\t============================\n")
        (display "\t   MENU\n")
        (display "\t============================\n")
        (display "\t0. Reset roster\n")
        (display "\t1. Load roster from file\n")
        (display "\t2. Exit\n\n")
        (display "\tEnter your choice: ")
        (performtask (read) roster)
      )
   )
)
