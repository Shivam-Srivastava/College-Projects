package entree;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import mdsj.MDSJ;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

@WebServlet("/Req_handler")
public class Req_handler extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static double[][] output_mds_values = new double[2][Model.NUM_DISP];
	private static int[] indexes = new int[Model.NUM_DISP];

	@SuppressWarnings("unchecked")
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
			throws ServletException, IOException {
		PrintWriter writer = resp.getWriter();
		
		try {
			if(req.getParameter("point") == null) {
				Model newmodel = new Model();
				
				indexes = newmodel.initialize();
				double[][] mdsinp = newmodel.getMDSInput(indexes);
				output_mds_values = MDSJ.classicalScaling(mdsinp);
				
				req.getSession().setAttribute("model", newmodel);
				
				JSONObject resp_obj = new JSONObject();
				JSONArray arr = new JSONArray();
				for(int i=0; i<output_mds_values[0].length; ++i) {
					JSONObject point = new JSONObject();
					point.put("x", output_mds_values[0][i]);
					point.put("y", output_mds_values[1][i]);
					point.put("restaurantID", indexes[i]);
					point.put("cheaper", Model.S_data[indexes[i]][0]);
					point.put("nicer", Model.S_data[indexes[i]][1]);
					point.put("traditional", Model.S_data[indexes[i]][2]);
					point.put("creative", Model.S_data[indexes[i]][3]);
					point.put("lively", Model.S_data[indexes[i]][4]);
					point.put("quiet", Model.S_data[indexes[i]][5]);
					
					String types = "<b>Characteristics: </b>";
					for(int j=0; j<Model.cuisine_data[j].length; ++j) {
						if(Model.cuisine_data[indexes[i]][j] > 0)
							types += Model.feature_map[Model.cuisine_data[indexes[i]][j]] + ", ";
						else if(Model.cuisine_data[indexes[i]][j]==0)
							continue;
						else
							break;
					}
					point.put("cuisines", types);
					
					arr.add(point);
				}
				resp_obj.put("points", arr);
				writer.write(resp_obj.toJSONString());
			} else {
				Model model = (Model) req.getSession().getAttribute("model");
				String point = req.getParameter("point");
				String[] arr = point.split(",");
				
				indexes = model.getNextRests(findMDSRest(Float.parseFloat(arr[0]), Float.parseFloat(arr[1])));
				double[][] mdsinp = model.getMDSInput(indexes);
				output_mds_values = MDSJ.classicalScaling(mdsinp);
				
				JSONObject resp_obj = new JSONObject();
				JSONArray arr2 = new JSONArray();
				for(int i=0; i<output_mds_values[0].length; ++i) {
					JSONObject point2 = new JSONObject();
					point2.put("x", output_mds_values[0][i]);
					point2.put("y", output_mds_values[1][i]);
					point2.put("restaurantID", indexes[i]);
					point2.put("cheaper", Model.S_data[indexes[i]][0]);
					point2.put("nicer", Model.S_data[indexes[i]][1]);
					point2.put("traditional", Model.S_data[indexes[i]][2]);
					point2.put("creative", Model.S_data[indexes[i]][3]);
					point2.put("lively", Model.S_data[indexes[i]][4]);
					point2.put("quiet", Model.S_data[indexes[i]][5]);
					
					String types = "<b>Characteristics:</b> ";
					for(int j=0; j<Model.cuisine_data[j].length; ++j) {
						if(Model.cuisine_data[indexes[i]][j] > 0)
							types += Model.feature_map[Model.cuisine_data[indexes[i]][j]] + ", ";
						else if(Model.cuisine_data[indexes[i]][j]==0)
							continue;
						else
							break;
					}
					point2.put("cuisines", types);
					
					arr2.add(point2);
				}
				resp_obj.put("points", arr2);
				writer.write(resp_obj.toJSONString());
			}
		} catch(Exception e) {
			e.printStackTrace();
		}
	}

	private int findMDSRest(float x, float y) {
		for(int i=0; i<output_mds_values[0].length; ++i) {
			if(Math.abs(output_mds_values[0][i] - x) < 0.00001 && Math.abs(output_mds_values[1][i] - y) < 0.00001)
				return indexes[i];
		}
		return -1;
	}

}
