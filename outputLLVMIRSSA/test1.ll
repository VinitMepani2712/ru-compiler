define i64 @foo(i64 %a) {
entry:
    %cmp = icmp ult i64 %a, 4
    br i1 %cmp, label %if.then, label %if.else

if.then:
    br label %if.end

if.else:
    br label %if.end

if.end:
    %b.alloc.0 = phi i64 [ 4, %if.then ], [ 6, %if.else ]
    br label %while.cond

while.cond:
    %b.alloc.1 = phi i64 [ %b.alloc.0, %if.end ], [ %t2, %while.body ]
    %c.alloc.0 = phi i64 [ 0, %if.end ], [ %t1, %while.body ]
    %cmp1 = icmp ugt i64 %b.alloc.1, 4
    br i1 %cmp1, label %while.body, label %while.end

while.body:
    %t1 = add i64 %c.alloc.0, %a
    %t2 = sub i64 %b.alloc.1, 1
    br label %while.cond

while.end:
    ret i64 %c.alloc.0
}
