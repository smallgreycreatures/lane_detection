times1 =  [  1.6482    0.9687    0.9915    0.9302    1.0525    1.0692    1.0206    1.0006    0.9612    0.9212];
times2 = [1.6706    1.0914    1.0960    1.1067    1.2154    1.1561    1.1388 1.1028    1.0591    1.0389];
plot([1:10],times1, [1:10], times2)
xlabel("attempt number")
ylabel("time taken [s]")


legend('With Kalman filter','Without Kalman filter')