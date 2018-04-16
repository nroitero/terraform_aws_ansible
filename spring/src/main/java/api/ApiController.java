package api;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;





@RestController
public class ApiController {

    @RequestMapping("/")
    public Api status(@RequestParam(value="name", defaultValue="true") String name) {
        return new Api( "alive"  );
    }



}
