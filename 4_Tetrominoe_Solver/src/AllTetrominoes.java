import java.util.Scanner;

public class AllTetrominoes {
	public static void main(String[] args){
		Scanner in = new Scanner(System.in);
		String inputChar = in.next();
		if(inputChar.equals("O")){
			printO();
		}
		else if(inputChar.equals("I")){
			printI();
		}
		else if(inputChar.equals("J")){
			printJ();
		}
		else if(inputChar.equals("L")){
			printL();
		}
		else if(inputChar.equals("S")){
			printS();
		}
		else if(inputChar.equals("T")){
			printT();
		}
		else if(inputChar.equals("Z")){
			printZ();
		}
	}

	private static void printZ() {
		System.out.println(" _ _");
		System.out.println("|_|_|");
		System.out.println("  |_|_|");
		
	}

	private static void printT() {
		System.out.println(" _ _ _");
		System.out.println("|_|_|_|");
		System.out.println("  |_|  ");
		
	}

	private static void printS() {
		System.out.println("   _ _");
		System.out.println(" _|_|_|");
		System.out.println("|_|_|");
	}

	private static void printL() {
		System.out.println("     _");
		System.out.println(" _ _|_|");
		System.out.println("|_|_|_|");
		
	}

	private static void printJ() {
		System.out.println(" _ _ _");
		System.out.println("|_|_|_|");
		System.out.println("    |_|");
		
	}

	private static void printI() {
		System.out.println(" _ _ _ _");
		System.out.println("|_|_|_|_|");
		
	}

	private static void printO() {
		System.out.println(" _ _");
		System.out.println("|_|_|");
		System.out.println("|_|_|");
		
	}
}
