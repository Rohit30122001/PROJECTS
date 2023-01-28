import java.util.*;

public class SortingALGO {
    public static void main(String[] args) {
        Scanner sc = new Scanner((System.in));
        System.out.println("Enter the number of elements:");
        int n = sc.nextInt();
        int[] arr = new int[n];
        System.out.println("Enter the array elements:");
        for(int i = 0;i<n;i++){
            arr[i] = sc.nextInt();
        }
        System.out.println("Enter the algorithm you want to use:");
        String s = sc.next();

        if(s.equals("bubble")){
            System.out.println("Bubble Sort is used:");
            bubbleSort(arr,n);
            printArray(arr,n);
        }
        else if(s.equals("selection")){
            System.out.println("Selection Sort is used:");
            selectionSort(arr,n);
            printArray(arr,n);
        }
        else if(s.equals("Insertion")){
            System.out.println("Insertion Sort is used:");
            insertionSort(arr,n);
            printArray(arr,n);
        }
        else if(s.equals("Merge")){
            System.out.println("Merge Sort is used:");
            MergeSort(arr,0,n-1);
            printArray(arr,n);
        }
        else if(s.equals("quick")){
            System.out.println("Quick Sort is used:");
            quickSort(arr,0,n-1);
            printArray(arr,n);
        }

    }
    static void bubbleSort(int[] arr, int n){
        boolean swapped;
        for(int i = 0;i<n-1;i++){
            swapped = false;
            for(int j = 0;j<n-1-i;j++){
                if(arr[j] > arr[j+1]){
                    swap(arr,j,j+1);
                    swapped = true;
                }
            }
            if(swapped == false){
                break;
            }
        }
    }
    static void selectionSort(int[] arr, int n){
        for(int i = 0;i<n-1;i++){
            int min_ind = i;
            for(int j = i+1;j<n;j++){
                if(arr[j] < arr[min_ind]){
                    min_ind = j;
                }
            }
           swap(arr,i,min_ind);

        }
    }
    static void insertionSort(int[] arr,int n){
        for(int i = 1;i<n;i++){
            int key = arr[i];
            int j = i-1;
            while(j >= 0 && arr[j] > key){
                arr[j+1] = arr[j];
                j--;
            }
            arr[j+1] = key;
        }
    }

    static void MergeSort(int[] arr, int l,int r){
        if(l < r){
            int m = l  + (r - l)/2;
            MergeSort(arr,l,m);
            MergeSort(arr,m+1,r);
            merge(arr,l,m,r);
        }
    }
    static void merge(int[] arr,int l,int mid,int r){
        int n1 = mid - l + 1;
        int n2 = r - mid;

        int[] L = new int[n1];
        int[] R = new int[n2];

        for(int i = 0;i<n1;i++){
            L[i] = arr[l+i];
        }
        for(int j = 0;j<n2;j++){
            R[j] = arr[mid+1+j];
        }
        int i = 0,j = 0,k = l;

        while(i < n1 && j < n2){
            if(L[i] <= R[j]){
                arr[k++] = L[i++];
            }
            else{
                arr[k++] = R[j++];
            }
        }
        while(i < n1){
            arr[k++] = L[i++];
        }
        while(j < n2){
            arr[k++] = R[j++];
        }
    }
    static void quickSort(int[] arr,int low,int high){

        if(low < high){

            int pi = partition(arr,low,high);

            quickSort(arr,low,pi-1);
            quickSort(arr,low+1,high);
        }
    }
    static int partition(int[] arr,int low,int high){

        int pivot = arr[high];

        int i = (low-1);

        for(int j = low;j<= high-1;j++){
            if(arr[j] < pivot){
                i++;
                swap(arr,i,j);
            }
        }
        swap(arr,i+1,high);
        return (i+1);
    }


    static void swap(int[] arr,int i,int j){
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
    static void printArray(int[] arr, int n){
        for(int i = 0;i<n;i++){
            System.out.print(arr[i] + " ");
        }
    }
}
