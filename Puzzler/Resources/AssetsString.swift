//
//  StringAsset.swift
//  Buzzler
//
//  Created by Jeeyeun Park on 2021/12/22.
//

import Foundation

public struct AssetsString {
    
    public static let CATEGORY_CAREER = "경력사항"
    public static let CATEGORY_SEMINAR = "교육사항"
    public static let CATEGORY_EXTRA = "대외활동"
    public static let CATEGORY_AWARDS = "수상경력"
    public static let CATEGORY_LANG = "어학시험"
    public static let CATEGORY_CERTIFICATE = "자격증"
    public static let CATEGORY_EDU = "학력사항"
    
    public static let CATEGORY_EN_CAREER = "Career"
    public static let CATEGORY_EN_SEMINAR = "Seminar"
    public static let CATEGORY_EN_EXTRA = "Extra"
    public static let CATEGORY_EN_AWARDS = "Awards"
    public static let CATEGORY_EN_LANG = "Language"
    public static let CATEGORY_EN_CERTIFICATE = "Certificate"
    public static let CATEGORY_EN_EDU = "Edu"
    
    public static let CATEGORY = ["경력사항", "교육사항", "대외활동", "수상경력", "어학시험", "자격증", "학력사항"]
    public static let CATEGORY_EN = ["Career", "Seminar", "Extra", "Awards", "Language", "Certificate", "Edu"]
    public static let KEYWORD = ["창의성", "글로벌", "주도성", "열정", "도전", "책임감", "적응력", "소통", "협력", "문제해결", "성실함", "분석력", "실행력"]
    
    //카테고리 이미지 파일 이름
    public static let IMG_CATEGORY = ["Career_R", "Seminar_R", "Extra_R", "Awards_R", "Language_R", "Certificate_R", "Edu_R"]
    
    //placeholder message
    public static let PLACEHOLDER_CONTENT = "내용을 입력하세요."
    public static let PLACEHOLDER_MEMO = "활동 중 발생했던 문제 상황 및 해결 방안 등 중요한 내용을 자유롭게 기재하세요."
    
    //cell indentifier
    public static let tableCellIndentifier: String = "cell_home"
    public static let tableCellBasicIndentifier: String = "cell_home_basic"
    public static let tableCellNoTagIndentifier: String = "cell_home_noTag"
    public static let tableCellNoContentIndentifier: String = "cell_home_noContent"
    public static let tableCellTitleIdentifier: String = "cell_home_title"
    
}
