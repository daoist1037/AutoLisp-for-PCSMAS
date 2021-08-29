(defun c:fbtt ()
  (vl-load-com)
  (setq selection (ssget))
  (setq n (sslength selection))
  (setq i 0)
  (setq angFlag 0)
  (repeat n
    (setq temp (ssname selection i))
    (setq tempData (entget temp))
    (setq blockName (assoc 2 tempData))
    (if
      (or (= (cdr blockName) "S311 Right Direction Pipe")
          (= (cdr blockName) "S311 Left Direction Pipe")
          (= (cdr blockName) "PIPE WITHOUT ARROW")
      )
      (progn
        (setq strlist (pipeRead temp))
        (setq ang (textAngle temp))
        (setq insertPosition (textInsert temp))
        (setq position (cdr (assoc 10 tempData)))
        (setq angCu (cdr (assoc 50 tempData)))
        (if (= (cdr blockName) "S311 Right Direction Pipe")
          (setq angFlag PI)
          (setq angFlag 0)
        )'
        (if (= (cdr blockName) "PIPE WITHOUT ARROW")
          (setq angFlag -1)
        )
        (if (< angFlag 0)
          (textChange insertPosition ang strlist)
          (progn
            (if (and (> angCu 1.57) (< angCu 1.58))
              (progn
                (setq angArrow (/ Pi 2))
                (arrowChange position (+ angArrow angFlag))
                (textChange insertPosition ang strlist)
              )
              (progn
                (setq angArrow 0)
                (arrowChange position (+ angArrow angFlag))
                (textChange insertPosition ang strlist)
              )
            )
          )
        )
        (entdel temp)
      )
    )
    (if (/= blockName nil)
      (progn
        (if
          (or (vl-string-search "Valve" (cdr blockName))
              (vl-string-search "VALVE" (cdr blockName))
              (= (cdr blockName) "Fitting Numbering")
              (= (cdr blockName) "99MI74-1")
          )
          (progn
            (setq tempVla (vlax-ename->vla-object temp))
            (setq attlist (vlax-safearray->list
                            (vlax-variant-value (vla-getattributes tempvla))
                          )
            )
            (setq ent (nth 0 attlist))
            (setq strlist (vla-get-TextString ent))
            (setq ang (textAngle temp))
            (setq insertPosition (textInsert temp))
            (if (and (> ang 1.57) (< ang 1.58))
              (progn
                (setq insertPosition (list (car insertPosition)
                                           (+ (cadr insertPosition) 2)
                                           (caddr insertPosition)
                                     )
                )
              )
              (progn
                (setq insertPosition (list (+ (car insertPosition) 2)
                                           (cadr insertPosition)
                                           (caddr insertPosition)
                                     )
                )
              )
            )
            (vla-delete ent)
            (textChange insertPosition ang strlist)
          )
        )
      )
    )
    (setq i (+ i 1))
  )
)

(defun pipeRead (temp / tempVla attlist aN mm strlist ent enttext)
  (setq tempVla (vlax-ename->vla-object temp))
  (setq attlist (vlax-safearray->list (vlax-variant-value (vla-getattributes tempvla))))
  (setq aN (length attlist))
  (setq mm 0)
  (setq strlist "")
  (repeat 7
    (setq ent (nth mm attlist))
    (setq enttext (vla-get-TextString ent))
    (setq strlist (strcat strlist "-" enttext))
    (setq mm (+ mm 1))
  )
  (setq strlist (substr strlist 2))
)
(defun textAngle (temp / tempVla attlist a)
  (setq tempVla (vlax-ename->vla-object temp))
  (setq attlist (vlax-safearray->list (vlax-variant-value (vla-getattributes tempVla))))
  (setq a (nth 0 attlist))
  (setq ang (vla-get-rotation a))
)
(defun textInsert (temp / tempVla attlist a)
  (setq tempVla (vlax-ename->vla-object temp))
  (setq attlist (vlax-safearray->list (vlax-variant-value (vla-getattributes tempVla))))
  (setq a (nth 0 attlist))
  (setq insertPosition (vla-get-insertionpoint a))
  (setq insertPosition (vlax-safearray->list (vlax-variant-value insertPosition)))
)
(defun textChange (position ang strlist)
  (entmake
    (list
      '(0 . "TEXT")
      '(5 . "A7E2C")
      '(100 . "AcDbEnity")
      (cons 67 0)
      '(410 . "Model")
      '(8 . "1_Text")
      (cons 370 13)
      '(100 . "AcDbText")
      (cons 10 position)
      (cons 1 strlist)
      (cons 40 2.5)
      (cons 50 ang)
      (cons 41 0.8)
      (cons 51 0)
      '(7 . "ROMANS")
      (cons 71 0)
      (cons 72 0)
    )
  )
)
(defun arrowChange (position ang)
  (entmake
    (list
      (cons 0 "INSERT")
      (cons 5 "A8366")
      (cons 102 "{ACAD_XDICTIONARY")
      (cons 102 "}")
      (cons 100 "AcDbEntity")
      (cons 67 0)
      (cons 410 "Model")
      (cons 8 "1 process")
      (cons 100 "AcDbBlockReference")
      (cons 2 "99MI41-1")
      (cons 10 position)
      (cons 41 24)
      (cons 42 24)
      (cons 43 24)
      (cons 50 ang)
      (cons 70 0)
      (cons 71 0)
      (cons 44 0)
      (cons 45 0)
    )
  )
)