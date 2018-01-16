(* Definitions for use with the -mono_rewrites option *)

(* External definitions not in the usual asl prelude *)

val "shiftleft" : forall 'n 'o ('ord : Order).
    (vector('o, 'n, 'ord, bit), int) -> vector('o, 'n, 'ord, bit) effect pure

overload operator << = {shiftleft}

val "shiftright" : forall 'n 'o ('ord : Order).
    (vector('o, 'n, 'ord, bit), int) -> vector('o, 'n, 'ord, bit) effect pure

overload operator >> = {shiftright}

val "extz" : forall 'n 'm 'o 'p. (atom('p),atom('m),vector('o, 'n, dec, bit)) -> vector('p, 'm, dec, bit) effect pure
val extzv : forall 'n 'm 'o 'p. vector('o, 'n, dec, bit) -> vector('p, 'm, dec, bit) effect pure
function extzv(v) = extz(sizeof('p), sizeof('m),v)

val "exts" : forall 'n 'm 'o 'p. (atom('p),atom('m),vector('o, 'n, dec, bit)) -> vector('p, 'm, dec, bit) effect pure
val extsv : forall 'n 'm 'o 'p. vector('o, 'n, dec, bit) -> vector('p, 'm, dec, bit) effect pure
function extsv(v) = exts(sizeof('p), sizeof('m),v)

(* Definitions for the rewrites *)

val slice_mask : forall 'n, 'n >= 0. (int, int) -> bits('n) effect pure
function slice_mask(i,l) =
  let one : bits('n) = extzv(0b1) in
  ((one << l) - one) << i

val is_zero_subrange : forall 'n, 'n >= 0.
  (bits('n), int, int) -> bool effect pure

function is_zero_subrange (xs, i, j) = {
  (xs & slice_mask(j, i-j)) == extzv(0b0)
}

val is_ones_subrange : forall 'n, 'n >= 0.
  (bits('n), int, int) -> bool effect pure

function is_ones_subrange (xs, i, j) = {
  let m : bits('n) = slice_mask(j,j-i) in
  (xs & m) == m
}

val slice_slice_concat : forall 'n 'm 'r, 'n >= 0 & 'm >= 0 & 'r >= 0.
  (bits('n), int, int, bits('m), int, int) -> bits('r) effect pure

function slice_slice_concat (xs, i, l, ys, i', l') = {
  let xs = (xs & slice_mask(i,l)) >> i in
  let ys = (ys & slice_mask(i',l')) >> i' in
  extzv(xs) << l' | extzv(ys)
}

val slice_zeros_concat : forall 'n 'p 'q 'r, 'r = 'p + 'q & 'n >= 0 & 'p >= 0 & 'q >= 0 & 'r >= 0.
  (bits('n), int, atom('p), atom('q)) -> bits('r) effect pure

function slice_zeros_concat (xs, i, l, l') = {
  let xs = (xs & slice_mask(i,l)) >> i in
  extzv(xs) << l'
}

(* Assumes initial vectors are of equal size *)

val subrange_subrange_eq : forall 'n, 'n >= 0.
  (bits('n), int, int, bits('n), int, int) -> bool effect pure

function subrange_subrange_eq (xs, i, j, ys, i', j') = {
  let xs = (xs & slice_mask(j,i-j)) >> j in
  let ys = (ys & slice_mask(j',i'-j')) >> j' in
  xs == ys
}

val subrange_subrange_concat : forall 'n 'o 'p 'm 'q 'r 's, 's = 'o - ('p - 1) + 'q - ('r - 1) & 'n >= 0 & 'm >= 0.
  (bits('n), atom('o), atom('p), bits('m), atom('q), atom('r)) -> bits('s) effect pure

function subrange_subrange_concat (xs, i, j, ys, i', j') = {
  let xs = (xs & slice_mask(j,i-j)) >> j in
  let ys = (ys & slice_mask(j',i'-j')) >> j' in
  extzv(xs) << i' - (j' - 1) | extzv(ys)
}

val place_subrange : forall 'n 'm, 'n >= 0 & 'm >= 0.
  (bits('n), int, int, int) -> bits('m) effect pure

function place_subrange(xs,i,j,shift) = {
  let xs = (xs & slice_mask(j,i-j)) >> j in
  extzv(xs) << shift
}

val place_slice : forall 'n 'm, 'n >= 0 & 'm >= 0.
  (bits('n), int, int, int) -> bits('m) effect pure

function place_slice(xs,i,l,shift) = {
  let xs = (xs & slice_mask(i,l)) >> i in
  extzv(xs) << shift
}

val zext_slice : forall 'n 'm, 'n >= 0 & 'm >= 0.
  (bits('n), int, int) -> bits('m) effect pure

function zext_slice(xs,i,l) = {
  let xs = (xs & slice_mask(i,l)) >> i in
  extzv(xs)
}

val sext_slice : forall 'n 'm, 'n >= 0 & 'm >= 0.
  (bits('n), int, int) -> bits('m) effect pure

function sext_slice(xs,i,l) = {
  let xs = (xs & slice_mask(i,l)) >> i in
  extsv(xs)
}