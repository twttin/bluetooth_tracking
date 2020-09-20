// Program to do automatic baseline correction and peak detection on an input
// voltammogram. The input is a text file, where each line contains an x and y
// data value separated by a space. There should be no blank/empty lines in the
// text file.
// Before running, paste filepath of input text file in main method.

import 'dart:math';
import 'dart:io';

//
//
//
//
// Main Method
//
// Output: Prints list of peaks (x coordinate followed by y coordinate)
//

List<double> voltammogrampeaks(List<double> yval, int command) {
  const degree = 4; // MUST SET MANUALLY -- should be between 2 - 10
  const xvalmin = 0.4; // minimum x value (voltage/potential)
  const xvalmax = 1; // maximum x value (voltage/potential)

  // Manually Set File Path of Text File with Input Data
  //String fileName = "C:/Users/nju20/Documents/SURF20/dataSamples/1-A.txt";

  var datalist; // list of input data from text file (contains both x and y)
  var xval = new List<double>(); // list of x data
  //var yval = new List<double>(); // list of y data from input text file
  double xvalinc; // increment value to compute x data values
  var xnew = new List<double>(); // x data after applying smoothing filter
  var ynew = new List<double>(); // y data after applying smoothing filter

  // reads text file and gets data values
  //var file = File(fileName).readAsString().then((String contents) {
    //var subdata = contents.replaceAll('\n', ' ');
    //datalist = subdata.split(' ');

    // gets the y input values and stores in yval
   /* for (int i = 1; i < datalist.length; i = i + 2) {
      yval.add(double.parse(datalist[i]));
    }*/

    // computes x data values and stores in xval. x data values range from
    // xvalmin to xvalmax and the number of x data points is the same as the
    // number of y data points
    xvalinc = (xvalmax - xvalmin) / yval.length;
    xval.add(xvalmin);
    for (int j = 1; j < yval.length; j++) {
      xval.add(xval[j - 1] + xvalinc);
    }

    // apply smoothing filter to input data and store in newData
    var newData = movingAvg(xval, yval);

    // get x and y data after applying the smoothing filter and store in
    // xnew and ynew respectively
    for (int k = 0; k < newData.length; k++) {
      if (k % 2 == 0) {
        xnew.add(newData[k]);
      } else {
        ynew.add(newData[k]);
      }
    }

    // get the baseline (baseline variable is a list of y axis data)
    var baseline = getBaseline(xnew, ynew, degree);

    // substract the baseline from the original curve (sub variable is a list
    // of y axis data)
    var sub = subBaseline(ynew, baseline);

    // get the peaks of the baseline corrected curve
    // newPeaks variable is a list of the peaks where the first index
    // corresponds to the x value of the first peak and the second index
    // corresponds to the y value of the first peak
    var newPeaks = getPeak(xnew, sub);
    if(command==0) return newPeaks;
    else if(command==1) return baseline;
    else if(command==2) return sub;
    else if(command==3) return ynew;
    
}

//
//
//
//
// Peak Detection (getPeak)
//
// Description:
// Gets the peaks of the input curve by checking if a point is greater than
// a specified number of data points both before and after it.
//
// Inputs:
// xval -- list of input x data
// yval -- list of input y data
//
// Output:
// peaks -- list of x coordinate followed by y coordinate for peaks of curve
//

List<double> getPeak(xval, yval) {
  // trendNum is the number of points used before and after a point to determine
  // if there is a trend in the curve to suggest that the point is a peak
  // A good number to use is 10
  // If you wish to not filter out the peaks based on trend comparison set
  // trendNum to 1
  const trendNum = 10; // MUST SET MANUALLY

  int i; // iterative variable used in for loop
  int k; // iterative variable used in for loop
  int j; // iterative variable used in for loop
  // counts is a variable used to count the number of times a data point
  // is listed in the potential peaks list, it is used to filter out the
  // real peaks based on a trend comparison of trendNum number of points
  var counts;
  var potentialPeaks = new List<double>(); // list of potential peaks
  var peaks = new List<double>(); // list of peaks

  counts = 0;
  // go through all the y data points to check if they are peaks
  for (i = trendNum; i < yval.length - trendNum; i++) {
    // compare the value of the data point with the value of the points before
    // and after it (the number of points to compare with is trendNum)
    for (k = 1; k < trendNum + 1; k++) {
      if ((yval[i] > yval[i - k]) & (yval[i] > yval[i + k])) {
        potentialPeaks.add(yval[i]); // add peak to a list of potential peaks
      }
    }
    // go through list of potential peaks and count the number of times a
    // data point appears in the list
    for (j = 0; j < potentialPeaks.length; j++) {
      if (potentialPeaks[j] == yval[i]) {
        counts++;
      }
    }
    // if the number of counts is equal to trendNum, then this means that the
    // data point was greater than all trendNum points before and after it and
    // thus, it is a peak
    if (counts == trendNum) {
      peaks.add(xval[i]); // add x value of the peak to the list of peaks
      peaks.add(yval[i]); // add y value of the peak to the list of peaks
    }

    counts = 0; // reset counts
    // clear the potential peaks list
    potentialPeaks.removeRange(0, potentialPeaks.length);
  }

  return peaks;
}

//
//
//
//
// Moving Average Filter (movingAvg)
//
// Description:
// Takes input x and y data and applies a moving average filter to smooth the
// data. The number of points used in the moving average filter is specified
// by the constant numPoints and must be manually set.
//
// Inputs:
// xval -- list of doubles for the x data
// yval -- list of doubles for the y data
//
// Output:
// data -- list of doubles that contains the x, y data after applying the moving
// average filter
//

List<double> movingAvg(xval, yval) {
  // numPoints is the number of points used to compute the average in the
  // moving average filter
  // A good number to use is 6
  // For a simple average (just 2 points) set to 2
  const numPoints = 3; // MUST SET MANUALLY

  // iterative variables to use in for loops below
  int i;
  int k;
  int j;
  int m;

  double sum; // sum of data points, used to compute average
  // list of y data after applying moving average filter
  var yavg = new List<double>();
  // list of x data after applying moving average filter
  var xavg = new List<double>();
  // list of x, y data after applying moving average filter
  var data = new List<double>();

  // y data after applying the moving average filter is stored in yavg
  // each point for the y data is computed by taking successive averages of
  // numPoints points from the input y data
  for (i = 0; i < yval.length - numPoints + 1; i++) {
    sum = 0.0;
    for (k = 0; k < numPoints; k++) {
      sum = sum + yval[i + k];
    }
    yavg.add(sum / numPoints);
  }

  // x data after applying moving average filter is the input x data
  // with the first numPoints-2 points removed
  for (m = numPoints - 1; m < xval.length; m++) {
    xavg.add(xval[m]);
  }

  // get x and y data after applying moving average filter and put in one
  // list called data
  for (j = 0; j < yavg.length; j++) {
    data.add(xavg[j]);
    data.add(yavg[j]);
  }
  return data;
}

//
//
//
//
// Subtract Baseline (subBaseline)
//
// Description:
// Substracts an input baseline from the input curve to give the new corrected
// curve.
//
// Inputs:
// yval -- list of doubles containing the y data for the original curve
// baseline -- list of doubles containing the y data for the baseline
//
// Output:
// yupdate -- list of doubles containing the new y data after subtracting the
// baseline from the input curve
//

List<double> subBaseline(yval, baseline) {
  int i; // iterative variable used for for loop
  var yupdate = List<double>(yval.length); // y data after subtraction

  // subtract the baseline values from the original input curve
  for (i = 0; i < yval.length; i++) {
    yupdate[i] = yval[i] - baseline[i];
  }
  return yupdate;
}

//
//
//
//
// Get Baseline (getBaseline)
//
// Description:
// Gets the baseline of an input curve by fitting a polynomial
// to the input curve and using these values as a threshold. This process is
// repeated for an optimal number of iterations.
//
// Inputs:
// xval -- list of input x data
// yval -- list of input y data
// degree -- int degree of polynomial to be fitted to curve
//
// Output:
// ybase -- list of the y values for the baseline
//

List<double> getBaseline(xval, yval, degree) {
  // threshold is the sum of differences between y values of successive
  // iterations in the polynomial fitting algorithm
  // threshold could be set to a very small value, but in theory it should be 0
  const threshold = 0; // MUST SET MANUALLY
  // maxiteration is the maximum number of iterations for the baseline algorithm
  // NOTE: the number of iterations should range from 7-20 and optimally be
  // around 10-15
  const maxiteration = 20;

  int i; // iterative variable used in for loop
  var elements = xval.length.toDouble(); // number of data points of input curve
  var ynew = List<double>(xval.length); // y values of polynomial fitting
  var ybase = List<double>(xval.length); // y values of baseline
  var yprev = List<double>(xval.length); // y values used for iterations
  var coef = List<double>(degree + 1); // coefficients of polynomial fit curve

  // sum is a variable to keep track of the sum of differences of y values of
  // successive iterations
  var sum = 1.0; // set to a random double value above the threshold
  var iteration = 0; // variable to keep track of number of iterations

  ybase = yval; // the input y values start off as the baseline values
  // continue repeating the polynomial fitting algorithm until the sum of
  // differences is less than the threshold value or if we have reached the
  // maximum number of iterations
  while ((sum.abs() > threshold) & (iteration < maxiteration)) {
    yprev = ybase; // baseline values become the previous iteration values
    sum = 0.0;
    // get the coefficients of the polynomial regression curve
    coef = polyfit(xval, ybase, degree, elements);
    // get the y values of the polynomial regression
    ynew = getPredictedVal(degree, coef, xval);
    // get the baseline values after using the polynomial points as a cut-off
    ybase = getValues(ybase, ynew);

    // calculate the sum of differences of the y values from the previous
    // iteration and the current iteration
    for (i = 0; i < ybase.length; i++) {
      sum = sum + (ybase[i] - yprev[i]);
    }
    iteration++;
  }

  return ybase;
}

//
//
//
//
// Gets Y Values After Polynomial Curve Cut-Off (getValues)
//
// Description:
// Takes the current voltammogram and cuts off the points that
// are greater than the threshold values, which are the polynomial fitted data
// points.
//
// Inputs:
// yprev -- list of y values of the current voltammogram in the baseline
// algorithm process
// ynew -- list of y values of the polynomial fitted curve, which act as the
// threshold cut-off points
//
// Output:
// yval -- list of y values after cutting off the voltammogram values that are
// greater than the polynomial values
//

List<double> getValues(yprev, ynew) {
  var yval = List<double>(yprev.length); // y values after polynomial cut-off

  // if the data point of the current voltammogram (yprev) is greater than the
  // threshold cut-off (ynew), then take the polynomial threshold point
  for (int i = 0; i < yprev.length; i++) {
    if (yprev[i] > ynew[i]) {
      yval[i] = ynew[i];
    } else {
      yval[i] = yprev[i];
    }
  }
  return yval;
}

//
//
//
//
// Gets Y Values of Polynomial Regression (getPredictedVal)
//
// Description:
// Gets the y values of the polynomial fitted curve.
//
// Inputs:
// degree -- degree of the polynomial regression
// coef -- coefficients of the polynomial regression
// xval -- x values of the original curve
//
// Output:
// yval -- y values of the polynomial fitted curve
//

List<double> getPredictedVal(degree, coef, xval) {
  int i; // iterative variable used in for loop
  int k; // iterative variable used in for loop
  var ynew; // y value to be added to the list yval
  // list of y values of the polynomial fitted curve
  var yval = List<double>(xval.length);

  // for each x value, calculate the corresponding y value data point
  for (k = 0; k < xval.length; k++) {
    ynew = 0;
    // calculate the y value using the coefficients of the polynomial regression
    for (i = 0; i < (degree + 1); i++) {
      ynew = ynew + (coef[i] * pow(xval[k], i));
    }
    yval[k] = ynew; // add the y value to the list of y data points
  }

  return yval;
}

//
//
//
//
// Gets coefficients of polynomial regression (polyfit)
//
// Description: This function gets the coefficients for the polynomial
// regression curve for an input set of data.
// NOTE: the code can be found implemented in c at:
// https://github.com/natedomin/polyfit/blob/master/polyfit.c
//
//
// Inputs:
// xval -- list of x data points
// yval -- list of y data points
// degree -- degree of polynomial to be fitted to the input curve
// elements -- number of data points in the input curve
//
// Output:
// coefficients -- list of coefficients for the polynomial regression,
// the i'th entry of the list corresponds to the coefficient of x^i

List<double> polyfit(xval, yval, degree, elements) {
  var maxDegree = 10; // UPDATE THIS IF WANT DEGREE MORE THAN 10
  var coefficients = List<double>(degree + 1);

  // make sure that number of data points is greater than or equal to degree
  if (xval.length < degree) {
    return coefficients;
  }

  var b = List<double>(maxDegree + 1);

  for (int t = 0; t < (maxDegree + 1); t++) {
    b[t] = 0.0;
  }

  var p = List<double>(((maxDegree + 1) * 2) + 1);

  for (int t = 0; t < (((maxDegree + 1) * 2) + 1); t++) {
    p[t] = 0.0;
  }

  var a = List<double>((maxDegree + 1) * 2 * (maxDegree + 1));

  for (int t = 0; t < ((maxDegree + 1) * 2 * (maxDegree + 1)); t++) {
    a[t] = 0.0;
  }

  var x;
  var y;
  var powx;

  int i;
  int j;
  int k;

  for (i = 0; i < elements; i++) {
    x = xval[i];
    y = yval[i];
    powx = 1;

    for (j = 0; j < (degree + 1); j++) {
      b[j] = b[j] + (y * powx);
      powx = powx * x;
    }
  }

  p[0] = elements;

  for (i = 0; i < elements; i++) {
    x = xval[i];
    powx = xval[i];

    for (j = 1; j < ((2 * (degree + 1)) + 1); j++) {
      p[j] = p[j] + powx;
      powx = powx * x;
    }
  }

  for (i = 0; i < (degree + 1); i++) {
    for (j = 0; j < (degree + 1); j++) {
      a[(i * (2 * (degree + 1))) + j] = p[i + j];
    }

    a[(i * (2 * (degree + 1))) + (i + (degree + 1))] = 1;
  }

  for (i = 0; i < (degree + 1); i++) {
    x = a[(i * (2 * (degree + 1))) + i];
    if (x != 0) {
      for (k = 0; k < (2 * (degree + 1)); k++) {
        a[(i * 2 * (degree + 1)) + k] = a[(i * (2 * (degree + 1))) + k] / x;
      }

      for (j = 0; j < (degree + 1); j++) {
        if ((j - i) != 0) {
          y = a[(j * (2 * (degree + 1))) + i];
          for (k = 0; k < (2 * (degree + 1)); k++) {
            a[(j * (2 * (degree + 1))) + k] = a[(j * (2 * (degree + 1))) + k] -
                y * a[(i * (2 * (degree + 1))) + k];
          }
        }
      }
    } else {
      return coefficients;
    }
  }

  for (i = 0; i < (degree + 1); i++) {
    for (j = 0; j < (degree + 1); j++) {
      x = 0;
      for (k = 0; k < (degree + 1); k++) {
        x = x + (a[(i * (2 * (degree + 1))) + (k + (degree + 1))] * b[k]);
      }
      coefficients[i] = x;
    }
  }

  return coefficients;
}
