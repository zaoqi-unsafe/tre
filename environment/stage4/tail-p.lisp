(fn tail? (x tail &key (test #'equal))
  (with (xlen  (length x)
         tlen  (length tail))
    (unless (< xlen tlen)
      (funcall test tail (subseq x (- xlen tlen))))))
