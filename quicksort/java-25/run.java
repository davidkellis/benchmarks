import java.io.*;
import java.util.*;

public class run {
    static void quickSort(double[] arr, int lo, int hi) {
        if (lo >= hi) return;
        double pivot = arr[(lo + hi) / 2];
        int i = lo, j = hi;
        while (i <= j) {
            while (arr[i] < pivot) i++;
            while (arr[j] > pivot) j--;
            if (i <= j) { double t = arr[i]; arr[i] = arr[j]; arr[j] = t; i++; j--; }
        }
        if (lo < j) quickSort(arr, lo, j);
        if (i < hi) quickSort(arr, i, hi);
    }

    public static void main(String[] args) throws Exception {
        List<Double> list = new ArrayList<>();
        BufferedReader br = new BufferedReader(new FileReader("numbers.txt"));
        String line;
        while ((line = br.readLine()) != null) {
            list.add(Double.parseDouble(line.trim()));
        }
        br.close();
        double[] nums = list.stream().mapToDouble(Double::doubleValue).toArray();
        quickSort(nums, 0, nums.length - 1);

        for (int i = 0; i < 10; i++) System.out.println(nums[i]);
        System.out.println("...");
        for (int i = nums.length - 10; i < nums.length; i++) System.out.println(nums[i]);
    }
}
