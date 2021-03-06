function [ eigenvalues ] = EigvalQRShifts( A, tol, imax )

    % Opis:
    % Funkcja oblicza wartosci wlasne macierzy symetrycznych metoda
    % QR z przesuni�ciami. QR wykonywana za pomoca funkcji qrmgs.
    
    % Algorytm:
    % Ide� pojedynczego kroku k jest przeksztalcenie A{k} do A{k+1}.
    % Jezeli wartosci wlasne leza blisko siebie, to aby poprawic szybkosc
    % zbieznosci, stosuje sie algorytm metody QR z przesunieciami.
    % W danym kroku dokonujemy rozbicia A{k} - p{k}*I na Q{k} i R{k} i wyliczamy
    % na ich podstawie A{k+1} w sposob: A{k+1} = R{k} * Q{k} + p{k}*I, co 
    % mozna sprowadzic do A{k+1} = Q{k}' * A{k} * Q{k}.
    % Ten algorytm konczy swoja prace w momencie:
    % - osiagniecia maksymalnej liczby iteracji
    % - przekroczenia tolerancji wartosci macierzy D
    
    % Wejscie:
    % D - macierz, kt�rej wyliczamy wartosci wlasne
    % tol - tolerancja (gorna granica wartosci) elementow zerowanych
    % imax -  maksymalna liczba iteracji
    
    % Wyjscie:
    % eigenvalues - wektor wartosci wlasnych macierzy D
    
    % Kod:
    
    n = size(A,1);
    eigenvalues = diag(zeros(n));
    
    % macierz poczatkowa (oryginalna)
    INITIALsubmatrix = A; 
    
    for k=n:-1:2,
        %macierz startowa dla jednej wart. wl.
        DK = INITIALsubmatrix;
        i = 0;
        while i <= imax && max( abs( DK(k,1:k-1) ) ) > tol
            % 2x2 podmacierz dolnego prawego rogu
            DD = DK(k-1:k, k-1:k);
            ev = roots([1, -(DK(k-1,k-1)+DK(k,k)), DK(k-1,k-1)*DK(k,k)-DK(k,k-1)*DK(k-1,k)]);
            
            if abs(ev(1) - DD(2,2)) < abs(ev(2) - DD(2,2)),
                % najblizsza DK(k,k) wart. wl. podm. DD
                shift = ev(1);
            else
                % najblizsza DK(k,k) wart. wl. podm. DD
                shift = ev(2);
            end
            
            % macierz przesunieta
            DK = DK - eye(k)*shift;
            % faktoryzacja QR
            [Q1, R1] = qr(DK);
            % macierz przeksztalcona
            DK = R1 * Q1 + eye(k) * shift;
            i = i+1;
        end
        
        if i > imax
            error('imax exceeded program terminated');
        end
        
        eigenvalues(k) = DK(k,k);
        if k>2,
            % deflacja macierzy
            INITIALsubmatrix = DK(1:k-1, 1:k-1);
        else
            % ostatnia wart. wl.
            eigenvalues(1) = DK(1,1);
        end
        
    end
            


end

