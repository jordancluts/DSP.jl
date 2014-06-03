using DSP, Base.Test

# Test 

#######################################
#
#  http://www.mathworks.com.au/help/signal/ref/freqz.html
#  Example 1: Frequency response from transfer function
#
#  dlmwrite('freqz-eg1.txt',[w, abs(h)], 'delimiter', '\t', 'precision', '%.12f')
#
#######################################

# Matlab
freqz_eg1_w_abs = readdlm(joinpath(dirname(@__FILE__), "data", "freqz-eg1.txt"),'\t')
matlab_w     = freqz_eg1_w_abs[:,1]
matlab_abs   = freqz_eg1_w_abs[:,2]

# Julia
b0 = 0.05634
b1 = [1  1]
b2 = [1 -1.0166 1]
a1 = [1 -0.683]
a2 = [1 -1.4461 0.7957]
b = b0*conv(vec(b1),vec(b2))
a = conv(vec(a1),vec(a2))

#=w     = linspace(0, 2*pi, 200)=#                 # Does not produce same values as matlab
h     = response(TFFilter(b, a), true, matlab_w)   # So use frequencies from matlab
h_abs = convert(Array{Float64}, abs(h))

# Test
@test_approx_eq h_abs matlab_abs

#=using Winston=#
#=figure = plot(matlab_w/pi, 20*log10(h_abs))=#
#=figure = oplot(matlab_w/pi, 20*log10(matlab_abs), "r--")=#
#=ylim(-100, 20)=#
#=ylabel("Magnitude (dB)")=#
#=xlabel("Normalised Frequency (x pi rad/s)")=#
#=file(figure, "MATLAB-freqz.png", width=1200, height=800)=#


#######################################
#
#  http://www.mathworks.com.au/help/signal/ref/freqs.html
#  Example 1: Frequency response from the transfer function
#
#  dlmwrite('freqs-eg1.txt',[w; mag; phasedeg]', 'delimiter', '\t', 'precision', '%.10f')
#
#######################################

# Julia
a = vec([1.0, 0.4, 1.0])
b = vec([0.2, 0.3, 1.0])
w = logspace(-1,1,50)

h        = response(TFFilter(b, a), false, w)
mag      = convert(Array{Float64}, abs(h))
phasedeg = (180/pi)*convert(Array{Float64}, angle(h))

# Matlab
freqs_eg1_w_mag_phasedeg = readdlm(joinpath(dirname(@__FILE__), "data", "freqs-eg1.txt"),'\t')
matlab_w     = freqs_eg1_w_mag_phasedeg[:,1]
matlab_mag   = freqs_eg1_w_mag_phasedeg[:,2]
matlab_phasedeg = freqs_eg1_w_mag_phasedeg[:,3]

# Test
@test_approx_eq w matlab_w
@test_approx_eq mag matlab_mag
@test_approx_eq phasedeg matlab_phasedeg

#=using Winston=#
#=figure = loglog(w, mag)=#
#=ylabel("Magnitude")=#
#=xlabel("Frequency (rad/s)")=#
#=file(figure, "MATLAB-freqs-mag.png", width=1200, height=800)=#

#=figure = semilogx(w, phasedeg)=#
#=ylim(-150, 0)=#
#=setattr(figure, draw_grid=true, tickdir=1)=#
#=ylabel("Phase (degrees)")=#
#=xlabel("Frequency (rad/s)")=#
#=file(figure, "MATLAB-freqs-phase.png", width=1200, height=800)=#

