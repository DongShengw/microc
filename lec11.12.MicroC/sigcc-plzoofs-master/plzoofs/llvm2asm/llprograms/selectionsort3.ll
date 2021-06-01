%arr = type [8 x i64]

@tmp = global %arr [ i64 5, i64 4, i64 3, i64 2, i64 1, i64 6, i64 7, i64 8]

define i64 @find_min_idx(i64 %start, i64 %len) {
  %fstidx = getelementptr %arr, %arr* @tmp, i32 0, i64 %start
  %currmin = load i64, i64* %fstidx
  %minptr = alloca i64
  %minidx = alloca i64
  store i64 %currmin, i64* %minptr
  store i64 %start, i64* %minidx
  %ptrtoi = alloca i64
  store i64 %start, i64* %ptrtoi
  br label %loop
loop:
  %i = load i64, i64* %ptrtoi
  %cmp1 = icmp ne i64 %i, %len
  br i1 %cmp1, label %check, label %exit
check:
  %ptr = getelementptr %arr, %arr* @tmp, i32 0, i64 %i
  %val = load i64, i64* %ptr
  %currentmin = load i64, i64* %minptr
  %cmp2 = icmp slt i64 %val, %currentmin
  br i1 %cmp2, label %found, label %notfound
found:
  store i64 %val, i64* %minptr
  store i64 %i, i64* %minidx
  %oldi = load i64, i64* %ptrtoi
  %a = add i64 1, %oldi
  store i64 %a, i64* %ptrtoi
  br label %loop
notfound:
  %old = load i64, i64* %ptrtoi
  %newi = add i64 1, %old
  store i64 %newi, i64* %ptrtoi
  br label %loop
exit:
  %ans = load i64, i64* %minidx
  ret i64 %ans
}

define void @selectionsort(i64 %start, i64 %len) {
  %done = icmp eq i64 %start, %len
  br i1 %done, label %finish, label %continue
continue:
  %minidx = call i64 @find_min_idx(i64 %start, i64 %len)
  %fstidx = getelementptr %arr, %arr* @tmp, i32 0, i64 %start
  %minptr = getelementptr %arr, %arr* @tmp, i32 0, i64 %minidx
  %swap = load i64, i64* %fstidx
  %min = load i64, i64* %minptr
  store i64 %min, i64* %fstidx
  store i64 %swap, i64* %minptr
  %newstart = add i64 1, %start
  call void @selectionsort(i64 %newstart, i64 %len)
  ret void
finish:
  ret void
}

define i64 @is_sorted(i64 %start, i64 %end) {
  %ptrtoi = alloca i64
  store i64 %start, i64* %ptrtoi
  br label %for
for:
  %i = load i64, i64* %ptrtoi
  %cmp1 = icmp ne i64 %i, %end
  br i1 %cmp1, label %checkorder, label %rettrue
checkorder:
  %ptr = getelementptr %arr, %arr* @tmp, i32 0, i64 %i
  %val = load i64, i64* %ptr
  %next = add i64 1, %i
  %nextptr = getelementptr %arr, %arr* @tmp, i32 0, i64 %next
  %nextelt = load i64, i64* %nextptr
  %cmp2 = icmp sle i64 %val, %nextelt
  br i1 %cmp2, label %isless, label %endloop
isless:
  %oldi = load i64, i64* %ptrtoi
  %a = add i64 1, %oldi
  store i64 %a, i64* %ptrtoi
  br label %for
endloop:
  ret i64 0
rettrue:
  ret i64 1
}

define i64 @main(i64 %argc, i8** %arcv) {
  call void @selectionsort(i64 0, i64 8)
  %sorted = call i64 @is_sorted(i64 0, i64 7)
  ret i64 %sorted
}

