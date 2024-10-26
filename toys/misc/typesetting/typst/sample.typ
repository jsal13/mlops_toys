#import "@preview/xarrow:0.3.1": xarrow

#set quote(block: true)
#show quote: set align(left)
#show quote: set pad(x: 2em)

= My Favorite Things

Sometimes I want to talk about my favorite things.  Here are some of them:

+ Iced Cream
+ Regular Cream
+ Onion Cream
  - Ranch Cream
  - Dance Cream

But I like other _non-creams_ too.  Not *many*, but some.

== Non-Creams
#v(0.5em)

*Theorem* (_Cauchy's Integral Formula_):

#pad(x: 1em)[
Let $U$ be an open subset of $bb(C)$.  Suppose the closed disk $D$, defined as 

$ D := {z : |z - z_0| lt.eq r } $

is completely contained in $U$.  Let $f: U -> bb(C)$ be holomorphic and let $gamma$ be the circle, oriented counterclockwise, forming the bounary of $D$.  Then for every $a$ in the interior of $D$:

$ f(a) = frac(1, 2 pi i) integral.cont_gamma frac(f(z), z - a) thin dif z . $
]

*Theorem* (_Mayer-Vietoris Sequence_):

#pad(x: 1em)[
Let $X$ be a topological space and let $A, B$ be two subspaces whose interiors cover $X$.  For the singular homology triad $(X, A, B)$ the following is a long exact sequence:

$ dots.c arrow H_(n+1)(X) 
  &xarrow(delta_star) H_n (A sect B)
  arrow.hook H_n (A) plus.circle H_n (B)
  arrow.hook H_n (X) arrow dots.c \

  dots.c &xarrow(delta_star) H_0 (A sect B) arrow.hook H_0 (A) plus.circle H_0 (B)
  arrow.hook H_0 (X) arrow 0.
$
]
