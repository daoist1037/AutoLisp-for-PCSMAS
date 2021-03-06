(defun c:fee ()
  (setq tempR (car (entsel "templateR")))
  (setq tempR (vlax-ename->vla-object tempR))
  (setq tempL (car (entsel "templateL")))
  (setq tempL (vlax-ename->vla-object tempL))
  (setq tempB (car (entsel "templateB")))
  (setq tempB (vlax-ename->vla-object tempB))
  (setq tempA (car (entsel "templateA")))
  (setq tempA (vlax-ename->vla-object tempA))

  (setq p1 (getpoint "p1"))
  (setq p2 (getpoint "p2"))
  (setq selection nil)
  (setq selection (ssget "C" p1 p2 '((2 . "OFFDRAW"))))
  (setq i 0)
  (repeat (sslength selection)
    (setq temp (ssname selection i))
    (setq tempVla (vlax-ename->vla-object temp))
    (setq inserTemp (vla-get-insertionpoint tempVla))
    (setq inserTemp (vlax-safearray->list (vlax-variant-value inserTemp)))
    (setq xfactor (vla-get-xeffectivescalefactor tempVla))
    (setq pp1 inserTemp)
    (setq rotation (vla-get-rotation tempVla))
    (setq flag nil)
    (if (= rotation 0)
      (setq pp2  (list (+ (car pp1) 20) (+ (cadr pp1) 8) 0)
            flag 2
      )
      (setq pp2  (list (- (car pp1) 8) (+ (cadr pp1) 20) 0)
            flag 1
      )
    )
    (setq ABC nil)
    (setq ABC (ssget "C" pp1 pp2 '((0 . "TEXT"))))
    (setq j 0)
    (setq strList nil)
    (repeat (sslength ABC)
      (setq tp (ssname ABC j))
      (setq strList (cons tp strList))
      (setq j (+ j 1))
    )
    (setq strList (vl-sort strList
                           (function
                             (lambda (e1 e2)
                               (<
                                 (setq e1y (nth flag (assoc 10 (entget e1))))
                                 (setq e2y (nth flag (assoc 10 (entget e2))))
                               )
                             )
                           )
                  )
    )
    (if (= flag 1)
      (setq strList (reverse strList))
    )

    ;
    (setq temp2 (vla-copy temp1))
    (vla-put-insertionpoint temp2 (vlax-3d-point inserTemp))
    (vla-put-xeffectivescalefactor temp2 xfactor)
    (setq attlist (vlax-safearray->list
                    (vlax-variant-value (vla-getattributes temp2))
                  )
    )
    (setq k 0)
    (setq entA nil
          entB nil
          entC nil
    )
    (repeat 3
      (setq ent (nth k attlist))
      (setq tagString (vla-get-tagstring ent))
      (cond
        ((= tagString "AAA")
         (setq entA ent)
        )
        ((= tagString "BBB")
         (setq entB ent)
        )
        ((= tagString "CCC")
         (setq entC ent)
        )
      )
      (setq k (+ k 1))
    )
    (setq k 0)
    (repeat (length strList)
      (setq str (nth k strList))
      (setq str (cdr (assoc 1 (entget str))))
      (cond
        ((= k 0)
         (vla-put-textstring entA str)
        )
        ((= k 1)
         (vla-put-textstring entB str)
        )
        ((= k 2)
         (vla-put-textstring entC str)
        )
      )
      (setq k (+ k 1))
    )
    (if (= k 2)
      (vla-put-textstring entC "")
    )
    (setq i (+ i 1))
  )
)

(defun c:fdd ()
  (setq a (car (entsel)))
  (setq a (vlax-ename->vla-object a))
  (vlax-dump-object a T)
)
