package kh.spring.controller;

import java.io.File;
import java.util.List;
import java.util.UUID;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.io.FileUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.google.gson.Gson;

import kh.spring.dto.SnsDTO;
import kh.spring.dto.SnsFilesDTO;
import kh.spring.service.SnsCommentService;
import kh.spring.service.SnsFilesService;
import kh.spring.service.SnsService;

@Controller
@RequestMapping("/sns")
public class SnsController {
	
	@Autowired
	private SnsService service;
	@Autowired
	private SnsCommentService scservice;
	@Autowired
	private SnsFilesService fservice;
	@Autowired
	private HttpSession session;
	
	@RequestMapping("/main")
	public String main(Model model) throws Exception {
		String id= (String)session.getAttribute("loginID"); //글 목록
		
		List<SnsDTO>list = service.selectAll(id);
		model.addAttribute("list", list);
		
		List<String> ldto = service.existlike(id); //좋아요목록
		model.addAttribute("isLove",ldto);

		List<SnsFilesDTO>fdto = fservice.sendList(session); //파일목록
		model.addAttribute("file", fdto);
		return "sns/main";
	}
	
	@RequestMapping("/modifyfile")
	@ResponseBody
	public String modifyfile(int parent) {
		List<SnsFilesDTO>list = fservice.modiFile(parent);
		Gson gs = new Gson();
		return gs.toJson(list);
	}
	
	@RequestMapping("/page")
	@ResponseBody
	public String page(int count) {
		String id = (String)session.getAttribute("loginID");
		int viewcount = 10;
		List<SnsDTO>list = service.page(id,viewcount,count);
		Gson g = new Gson();
		String result = g.toJson(list);
		return result;
		
	}
	
	@RequestMapping("/write")
	public String write(SnsDTO dto, MultipartFile[] file) throws Exception{
		String id = (String)session.getAttribute("loginID");
		int seq = service.seq();
		dto.setId(id);
		String region = service.region(id);
		dto.setRegion(region);
		if(file[0].getSize() ==0) {		 //파일이 없을때
			service.insert(seq ,dto);
			 
		}else {  //파일이 있을때
			service.insert(seq ,dto); 	
			String realPath = session.getServletContext().getRealPath("files");
			File filesPath = new File(realPath);
			
			if(!filesPath.exists()) {
				filesPath.mkdir();
			}
			for(MultipartFile tmp : file) {
				String oriName = tmp.getOriginalFilename();
				String sysName = UUID.randomUUID().toString().replaceAll("-", "")+ "_"+oriName;
				fservice.insert(oriName, sysName, seq,id);
				tmp.transferTo(new File(filesPath.getAbsolutePath()+"/"+sysName));
			}
		}			
		return "redirect:/sns/main";
	}
	
	@RequestMapping("/delete")
	public String delete(int seq) {
		service.delete(seq);
		fservice.delete(seq);
		return "redirect:/sns/main";
	}
	
	@RequestMapping("/delfile")
	@ResponseBody
	public int delfile(int seq) {
		int result = fservice.deleteFile(seq);
		return result;
	}
	
	@RequestMapping("/modify")
	public String modify(int seq, Model model) throws Exception {
		String id = (String)session.getAttribute("loginID");
		String contents = service.select(seq);
		model.addAttribute("contents", contents);
		model.addAttribute("seq", seq);
		
		List<SnsDTO>list = service.selectAll(id);		
		model.addAttribute("list", list);
		
		List<String> ldto = service.existlike(id); //좋아요목록
		model.addAttribute("isLove",ldto);
		
		List<SnsFilesDTO>fdto = fservice.sendList(session); //파일목록
		model.addAttribute("file", fdto);

		return "sns/modify";
	}
	
	@RequestMapping("/modiProc")
	public String modiProc(SnsDTO dto, MultipartFile[] file) throws Exception{
		String id = (String)session.getAttribute("loginID");
		int seq = dto.getSeq();
		int parent = dto.getSeq();
		String contents = dto.getContents();

		if(file[0].getSize() == 0) {
			service.modify(dto);
		}else {
			service.modify(dto);
			String realPath = session.getServletContext().getRealPath("files");
			File filesPath = new File(realPath);
			
			if(!filesPath.exists()) {
				filesPath.mkdir();
			}
			for(MultipartFile tmp : file) {
				String oriName = tmp.getOriginalFilename();
				String sysName = UUID.randomUUID().toString().replaceAll("-", "")+ "_"+oriName;
				fservice.insert(oriName, sysName, parent,id);
				tmp.transferTo(new File(filesPath.getAbsolutePath()+"/"+sysName));
			}
		}
		
		
		return "redirect:/sns/main";
	}
	
	@RequestMapping("love") //좋아요반영
	@ResponseBody
	public int love(int seq,int love) {
		String id = (String)session.getAttribute("loginID");
		int countexists = service.getlike(id,seq);
		int resultcode = 1;
		if(countexists == 0) { //처음눌렀을때
			service.love(seq, love);
			service.pluslove(id, seq);
			resultcode = 1;
		}else {
			int count = service.getcount(id, seq);
			if(count ==1) { //취소했을때
				service.cancellove(seq, love);
				service.minuslove(id, seq);
				resultcode = 0;
			}else { //취소후 다시눌렀을때
				service.love(seq, love);
				service.updatecount(id, seq);
				resultcode = 1;
			}
		}		
		return resultcode;
	}
	
	@RequestMapping("/download") //사진다운로드
	public void download(String oriName, String sysName, HttpServletResponse resp) throws Exception{
		String filesPath = session.getServletContext().getRealPath("files");
		File targetFile = new File(filesPath + "/" + sysName);
		
		resp.setContentType("application/octet-stream; charset=utf-8");
		resp.setHeader("content-Disposition", "attachment;filename=\""+ oriName + "\"");
		
		try(ServletOutputStream sos = resp.getOutputStream();){
			FileUtils.copyFile(targetFile, sos);
			sos.flush();
		}
	}
		
}
