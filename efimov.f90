program efimov

  use constants
  
  implicit none
  
  !.. Input
  !.. Parameters for the B-splines used in the generalized eigenvalue equation
  integer, parameter :: N1 = 5   !.. Number of mesh-points in coordinate 1
  integer, parameter :: N2 = 5   !.. Number of mesh-points in coordinate 2
  integer, parameter :: k = 6    !.. B-spline order
  integer, parameter :: L = 7    !.. Number of B-splines in coordinate 1(N+k-2-cond)
  integer, parameter :: M = 7    !.. Number of B-splines in coordinate 2
  integer, parameter :: LM = 49 !.. Matrix dimension
  integer, parameter :: npl = 15  !.. Number of knot-points  N1+2(k-1)
  integer, parameter :: npm = 15  !.. Number of knot-points  N2+2(k-1)
 

  !.. Parameters for the knot-point grids tl and tm
  real(kind(1.d0)) :: tl(npl), tm(npm), tl_max, tm_max, tl_min, tm_min
  real(kind(1.d0)) :: tld(npl), tmd(npm), tld_max, tmd_max, tld_min, tmd_min 
  real(kind(1.d0)) :: energy(3)

  !.. Parameters for the 2-body potential
  real(kind(1.d0)) :: d(7)
  real(kind(1.d0)) :: r0,r(3), potential(3)
  real(kind(1.d0)) :: mass(3)
  real(kind(1.d0)) :: V,theta,phi

  !.. Parameters for the energy curve
  integer, parameter :: points = 1000
  real(kind(1.d0))   :: rho_vector(points), energy_curve(7,points)

  !.. Parameters for plotting
  integer, parameter :: pp = 100
  integer, parameter :: ss = 4
  real(kind(1.d0)) :: x(pp), y(pp), step_size_x, step_size_y, alpha
  real(kind(1.d0)) :: base(pp,LM)

  !.. Parameters for the wave function
  real(kind(1.d0))   :: wfn(pp,pp,ss), f(LM,ss), c(L,M,ss), term(ss), base_L(pp,L), base_M(pp,M)


  !.. Other parameters
  real(kind(1.d0)) :: rho, my, H(LM,LM), S(LM,LM),t1,t2,s0,lamda, Vtrap(points), angfreq, osc
  integer :: i,j,ii, ll, mm, n

  
  r0 = 55.d0
  mass = 87.d0*1836.15d0
  s0 = 1.00624d0
  my = mass(1)/sqrt(3.d0)
  lamda = 4.d0
  angfreq = 2.d0*Pi*78.d0*10**3.d0
  osc = sqrt(1.d0/(mass(1)*angfreq))
 

  d(1) = -6.619d0*10**(-8.d0)
  
  
  tl_min = 0.d0
  tl_max = Pi/2.d0
  tm_min = 0
  tm_max = Pi/3.d0

  ! tld_min = 0.d0
  ! tld_max = Pi/2.d0
  ! tmd_min = 0.d0
  ! tmd_max = Pi

  call universal_knot(npl,k,N1,tl_max,tl_min,tl)
  call universal_knot(npm,k,N2,tm_max,tm_min,tm)

  ! call universal_knot(npl,k,N1,tld_max,tld_min,tld)
  ! call universal_knot(npm,k,N2,tmd_max,tmd_min,tmd)

  rho_vector(1) = 1.0d0
  rho_vector(points) = 1000.d0
  step_size_x = (rho_vector(1)+rho_vector(points))/points
  do i = 2, points-1
     rho_vector(i) = rho_vector(i-1)+step_size_x
  end do

  !Setting up trapping potential

  Vtrap = 0.5d0*my*(angfreq*rho_vector)**2.d0

 
  

  call efimovham(npl,npm,k,L,M,LM,tl,tm,rho_vector(1),my,r0,d(1),mass,energy,H,S)
  !call delvesham(npl,npm,k,L,M,LM,tld,tmd,rho_vector(1),my,r0,d(1),mass,energy,H,S)

  

  !.. Code for plotting eigenfunctions start

  ! do n = 1, ss
!      do i = 1, LM
!         f(i,n) = H(i,n)
!      end do
!   end do

!   do ll = 1, L
!      do mm = 1, M
!         do n = 1, ss
!            i = (ll-1)*M+mm
!            c(ll,mm,n) = f(i,n)
!         end do
!      end do
!   end do
  
!   !.. Setting up vector for plotting
!   x(1) = tl(k)
!   x(pp) = tl(np)
!   y(1) = tm(k)
!   y(pp) = tm(np)

!   step_size_x = (x(pp)-x(1))/pp
!   step_size_y = (y(pp)-y(1))/pp

!   do ii = 2, pp-1
!      x(ii) = x(ii-1)+step_size_x
!      y(ii) = y(ii-1)+step_size_y
!   end do

!   call B_spline_base(np,k,L,M,tl,tm,pp,x,y,base_L,base_M)

!  do n = 1, ss
!      do j = 1, pp
!         do i = 1, pp
!            term = 0.0
!            do ll = 1, L
!               do mm = 1, M
!                  term(n) = term(n) + c(ll,mm,n)*base_L(i,ll)*base_M(j,mm)
!               end do
!            end do
!            wfn(i,j,n) = term(n)
!         end do
!      end do
!   end do

!   open(20,file='result_wave.dat',status='replace')
  
!   do j = 1, pp
!      do i = 1, pp
!         write(20,10)i, j, x(i), y(j), wfn(i,j,1)**2.d0, wfn(i,j,2)**2.d0, wfn(i,j,3)**2.d0
! 10      format(I4, I4,'  ',16f20.8)
!      end do
!   end do
!   close(20)

  !.. Code for plotting eigenfunction end
  
  
  call CPU_TIME( t1 )
    write(6,*) 'hej5', points
  do i = 1, points
     rho = rho_vector(i)
     WRITE(6,*) "A",I
     call efimovham(npl,npm,k,L,M,LM,tl,tm,rho,my,r0,d(1),mass,energy,H,S)
     WRITE(6,*) "b",I
     energy_curve(1,i) = energy(1)
     energy_curve(2,i) = energy(2)
     energy_curve(3,i) = energy(3)
     
  end do
  write(6,*) 'hej6'
  call CPU_TIME( t2 )
  print*, t2-t1
  write(6,*) 'hej7'
 
  ! call CPU_TIME( t1 )
  
  ! do i = 1, points
  !    rho = rho_vector(i)
  !    call efimovham(npl,npm,k,L,M,LM,tl,tm,rho,my,r0,d(1),mass,energy,H,S)
  !    energy_curve(1,i) = energy(1)
  !    energy_curve(2,i) = energy(2)
  !    energy_curve(3,i) = energy(3)
  ! end do

  ! call CPU_TIME( t2 )
  ! print*, t2-t1

 
  
  open(10,file='result2.dat',status='replace')
  do i = 1, points
     write(10,10)i, rho_vector(i)/osc, (energy_curve(1,i)+Vtrap(i))/angfreq,(energy_curve(2,i)+Vtrap(i))/angfreq , (lamda*(lamda+4)+15.d0/4.d0)*10.d0**(8.d0)/(2.d0*my*rho_vector(i)**2.d0)
10   format(I3,'  ',16f20.8)
  end do
  close(10)

 !energy_curve(1,i)*10**(8.d0), energy_curve(2,i)*10**(8.d0)
end program efimov

   
