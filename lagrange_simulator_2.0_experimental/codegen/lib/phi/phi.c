/*
 * Academic License - for use in teaching, academic research, and meeting
 * course requirements at degree granting institutions only.  Not for
 * government, commercial, or other organizational use.
 * File: phi.c
 *
 * MATLAB Coder version            : 3.3
 * C/C++ source code generated on  : 26-Jul-2018 11:14:04
 */

/* Include Files */
#include "rt_nonfinite.h"
#include "phi.h"
#include "phi_emxutil.h"
#include "rdivide.h"
#include "power.h"

/* Function Declarations */
static double rt_powd_snf(double u0, double u1);

/* Function Definitions */

/*
 * Arguments    : double u0
 *                double u1
 * Return Type  : double
 */
static double rt_powd_snf(double u0, double u1)
{
  double y;
  double d0;
  double d1;
  if (rtIsNaN(u0) || rtIsNaN(u1)) {
    y = rtNaN;
  } else {
    d0 = fabs(u0);
    d1 = fabs(u1);
    if (rtIsInf(u1)) {
      if (d0 == 1.0) {
        y = 1.0;
      } else if (d0 > 1.0) {
        if (u1 > 0.0) {
          y = rtInf;
        } else {
          y = 0.0;
        }
      } else if (u1 > 0.0) {
        y = 0.0;
      } else {
        y = rtInf;
      }
    } else if (d1 == 0.0) {
      y = 1.0;
    } else if (d1 == 1.0) {
      if (u1 > 0.0) {
        y = u0;
      } else {
        y = 1.0 / u0;
      }
    } else if (u1 == 2.0) {
      y = u0 * u0;
    } else if ((u1 == 0.5) && (u0 >= 0.0)) {
      y = sqrt(u0);
    } else if ((u0 < 0.0) && (u1 > floor(u1))) {
      y = rtNaN;
    } else {
      y = pow(u0, u1);
    }
  }

  return y;
}

/*
 * Arguments    : const emxArray_real_T *s
 *                const emxArray_real_T *q
 *                const emxArray_real_T *qdot
 *                const emxArray_real_T *qddot
 *                double L
 *                emxArray_real_T *out
 * Return Type  : void
 */
void phi(const emxArray_real_T *s, const emxArray_real_T *q, const
         emxArray_real_T *qdot, const emxArray_real_T *qddot, double L,
         emxArray_real_T *out)
{
  emxArray_real_T *r0;
  emxArray_real_T *r1;
  int n;
  emxArray_real_T *y;
  unsigned int uv0[2];
  int k;
  emxArray_real_T *r2;
  emxArray_real_T *b_q;
  double c_q;
  emxArray_real_T *r3;
  emxArray_real_T *r4;
  emxArray_real_T *r5;
  double d_q;
  (void)qdot;
  (void)qddot;
  emxInit_real_T(&r0, 2);
  emxInit_real_T(&r1, 2);
  power(s, r1);
  rdivide(r1, L * L, r0);
  for (n = 0; n < 2; n++) {
    uv0[n] = (unsigned int)s->size[n];
  }

  emxInit_real_T(&y, 2);
  n = y->size[0] * y->size[1];
  y->size[0] = (int)uv0[0];
  y->size[1] = (int)uv0[1];
  emxEnsureCapacity((emxArray__common *)y, n, sizeof(double));
  n = s->size[0] * s->size[1];
  for (k = 0; k + 1 <= n; k++) {
    y->data[k] = rt_powd_snf(s->data[k], 3.0);
  }

  emxInit_real_T(&r2, 2);
  power(s, r1);
  n = r2->size[0] * r2->size[1];
  r2->size[0] = r1->size[0];
  r2->size[1] = r1->size[1];
  emxEnsureCapacity((emxArray__common *)r2, n, sizeof(double));
  k = r1->size[0] * r1->size[1];
  for (n = 0; n < k; n++) {
    r2->data[n] = 3.0 * r1->data[n];
  }

  emxInit_real_T(&b_q, 2);
  rdivide(r2, L * L, r1);
  n = b_q->size[0] * b_q->size[1];
  b_q->size[0] = s->size[0];
  b_q->size[1] = s->size[1];
  emxEnsureCapacity((emxArray__common *)b_q, n, sizeof(double));
  c_q = q->data[0];
  k = s->size[0] * s->size[1];
  emxFree_real_T(&r2);
  for (n = 0; n < k; n++) {
    b_q->data[n] = c_q * s->data[n];
  }

  emxInit_real_T(&r3, 2);
  emxInit_real_T(&r4, 2);
  rdivide(b_q, L, out);
  rdivide(s, L, r3);
  n = r4->size[0] * r4->size[1];
  r4->size[0] = y->size[0];
  r4->size[1] = y->size[1];
  emxEnsureCapacity((emxArray__common *)r4, n, sizeof(double));
  k = y->size[0] * y->size[1];
  emxFree_real_T(&b_q);
  for (n = 0; n < k; n++) {
    r4->data[n] = 2.0 * y->data[n];
  }

  emxInit_real_T(&r5, 2);
  rdivide(r4, rt_powd_snf(L, 3.0), y);
  rdivide(s, L, r5);
  n = out->size[0] * out->size[1];
  emxEnsureCapacity((emxArray__common *)out, n, sizeof(double));
  n = out->size[0];
  k = out->size[1];
  c_q = q->data[1];
  d_q = q->data[2];
  k *= n;
  emxFree_real_T(&r4);
  for (n = 0; n < k; n++) {
    out->data[n] = (out->data[n] + c_q * (r0->data[n] - r3->data[n])) + d_q *
      ((y->data[n] - r1->data[n]) + r5->data[n]);
  }

  emxFree_real_T(&r5);
  emxFree_real_T(&r3);
  emxFree_real_T(&r1);
  emxFree_real_T(&y);
  emxFree_real_T(&r0);
}

/*
 * File trailer for phi.c
 *
 * [EOF]
 */
