(defun c:foo () 
  (setq sequenceStr (getstring "Please input the start pipe string:"))

  (setq valveSequence (getstring "Please input the start pipe string:"))

  (setq strFor (substr sequenceStr 1 4))
  (setq sequence (ATOI (substr sequenceStr 5)))

  (setq valveFor (substr valveSequence 1 2))
  (setq valveLa (ATOI (substr valveSequence 3)))
  (setq sel (ssget))
  (setq n (sslength sel))

  (setq newList '())
  (setq valveList '())

  (setq i 0)
  (repeat n 
    (setq temp (ssname sel i))
    (setq tempData (entget temp))
    (setq category (assoc 0 tempData))
    (if (or (= (cdr category) "TEXT") (= (cdr category) "MTEXT")) 
      (progn 
        (setq content (cdr (assoc 1 tempData)))
        (if (> (strlen content) 18) 
          (setq newList (cons temp newList))
        )
        (if (= (strlen content) 8) 
          (setq valveList (cons temp valveList))
        )
      )
    )
    (setq i (+ i 1))
  )
  (initget "l r a b")
  (setq ttype (getkword "\nleft(l)/right(r)/above(a)/below(b):"))


  (cond 
    ((= ttype "l")
     (setq newList (vl-sort newList 
                            (function 
                              (lambda (e1 e2) 
                                (< 
                                  (setq e1X (nth 1 (assoc 10 (entget e1))))
                                  (setq e2X (nth 1 (assoc 10 (entget e2))))
                                )
                              )
                            )
                   )
     )
    )
    ((= ttype "r")
     (setq newList (vl-sort newList 
                            (function 
                              (lambda (e1 e2) 
                                (> 
                                  (setq e1X (nth 1 (assoc 10 (entget e1))))
                                  (setq e2X (nth 1 (assoc 10 (entget e2))))
                                )
                              )
                            )
                   )
     )
    )
    ((= ttype "a")
     (setq newList (vl-sort newList 
                            (function 
                              (lambda (e1 e2) 
                                (> 
                                  (setq e1y (nth 2 (assoc 10 (entget e1))))
                                  (setq e2y (nth 2 (assoc 10 (entget e2))))
                                )
                              )
                            )
                   )
     )
    )
    ((= ttype "b")
     (setq newList (vl-sort newList 
                            (function 
                              (lambda (e1 e2) 
                                (< 
                                  (setq e1y (nth 2 (assoc 10 (entget e1))))
                                  (setq e2y (nth 2 (assoc 10 (entget e2))))
                                )
                              )
                            )
                   )
     )
    )
  )

  (cond 
    ((= ttype "l")
     (setq valveList (vl-sort valveList 
                            (function 
                              (lambda (e1 e2) 
                                (< 
                                  (setq e1X (nth 1 (assoc 10 (entget e1))))
                                  (setq e2X (nth 1 (assoc 10 (entget e2))))
                                )
                              )
                            )
                   )
     )
    )
    ((= ttype "r")
     (setq valveList (vl-sort valveList 
                            (function 
                              (lambda (e1 e2) 
                                (> 
                                  (setq e1X (nth 1 (assoc 10 (entget e1))))
                                  (setq e2X (nth 1 (assoc 10 (entget e2))))
                                )
                              )
                            )
                   )
     )
    )
    ((= ttype "a")
     (setq valveList (vl-sort valveList 
                            (function 
                              (lambda (e1 e2) 
                                (> 
                                  (setq e1y (nth 2 (assoc 10 (entget e1))))
                                  (setq e2y (nth 2 (assoc 10 (entget e2))))
                                )
                              )
                            )
                   )
     )
    )
    ((= ttype "b")
     (setq valveList (vl-sort valveList 
                            (function 
                              (lambda (e1 e2) 
                                (< 
                                  (setq e1y (nth 2 (assoc 10 (entget e1))))
                                  (setq e2y (nth 2 (assoc 10 (entget e2))))
                                )
                              )
                            )
                   )
     )
    )
  )

  (setq n (length newList))
  (setq i 0)
  (repeat n 
    (setq temp2Data (entget (nth i newList)))
    (setq oldr (assoc 1 temp2Data))
    (setq pipeSplit (strSplit (cdr oldr)))
    (if (and (> sequence 0) (< sequence 10)) 
      (setq strNum (strcat "0" (ITOA sequence)))
      (setq strNum (ITOA sequence))
    )
    (setq newSequence (strcat strFor strNum))
    (setq newPipeText (strcat (nth 0 pipeSplit) newSequence (nth 2 pipeSplit)))
    (setq newr (cons 1 newPipeText))
    (setq temp2Data (subst newr oldr temp2Data))
    (entmod temp2Data)
    (setq sequence (+ 1 sequence))
    (setq i (+ i 1))
  )

  (setq n (length valveList))
  (setq i 0)
  (repeat n 
    (setq temp2Data (entget (nth i valveList)))
    (setq oldr (assoc 1 temp2Data))
    (if (and (> valveLa 0) (< valveLa 1000)) 
      (setq strNum (strcat "0" (ITOA valveLa)))
      (setq strNum (ITOA num))
    )
    (setq newr (cons 1 (strcat valveFor (substr (cdr oldr) 3 2) strNum)))
    (setq temp2Data (subst newr oldr temp2Data))
    (entmod temp2Data)
    (setq valveLa (+ 1 valveLa))
    (setq i (+ i 1))
  )

  (prin1)
)

(defun strSplit (dataStr / n i part strList twoLoc fourLoc sixLoc) 
  (setq n (strlen dataStr))
  (setq i 1)
  (setq twoLoc 0)
  (setq fourLoc 0)
  (setq sixLoc 0)
  (setq strList '()
        part    ""
  )
  (while (/= n 0) 
    (if (= twoLoc 0) 
      (progn 
        (setq part (substr dataStr i 2))
        (if (wcmatch part "##") 
          (progn (if (> i 6)
                   (setq twoLoc i)
                 )
            )
        )
        (setq part (substr dataStr i 6))
        (if (wcmatch part "######") 
          (progn 
            (setq sixLoc i)
            (setq n 1)
          )
        )
      )
      (progn 
        (setq part (substr dataStr i 4))
        (if (wcmatch part "####") 
          (progn 
            (setq fourLoc i)
            (setq n 1)
          )
        )
      )
    )
    (setq i (+ 1 i))
    (setq n (- n 1))
  )
  (if (and (/= twoLoc 0) (/= fourLoc 0)) 
    (progn 
      (setq strList (cons (substr dataStr 1 (- twoLoc 1)) strList))
      (setq strList (cons (substr dataStr twoLoc (- (+ fourLoc 4) twoLoc)) strList))
      (setq strList (cons (substr dataStr (+ fourLoc 4)) strList))
    )
  )
  (if (/= sixLoc 0) 
    (progn 
      (setq strList (cons (substr dataStr 1 (- sixLoc 1)) strList))
      (setq strList (cons (substr dataStr sixLoc 6) strList))
      (setq strList (cons (substr dataStr (+ sixLoc 6)) strList))
    )
  )
  (reverse strList)
)
