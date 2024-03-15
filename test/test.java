public class test{
    public static void main(String[] args){
        count_sum(4);
    }

    public static int count_sum(int n){
        int sum = 0;
        for(int i = 0; i < n; ++i){
            for(int j = 0; j < n; ++j){
                System.out.println("J Iteration " + j + ": " + " sum = " + sum);
                sum += j;
            }
            System.out.println("I Iteration " + i + ": " + " sum = " + sum);
            sum += i;
        }
        return sum;
    }
}