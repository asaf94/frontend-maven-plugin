package org.t246osslab.easybuggy4sb.errors;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class OutOfMemoryErrorController {

	@RequestMapping(value = "/oome")
	public void process() {
		StringBuilder sb = new StringBuilder();
		while (true) {
			sb.append("OutOfMemoryError!");
		}
	}
}
