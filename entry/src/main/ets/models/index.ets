//分类
export interface QuestionType{
  id:number
  name:string
  displayNewestFlag:0|1
}

// 试题
export interface QuestionItem {
  id: string;
  /* 题干 */
  stem: string;
  /* 难度 */
  difficulty: number;
  /* 点赞数 */
  likeCount: number;
  /* 浏览数 */
  views: number;
  /* 是否已看 */
  readFlag: 0 | 1;
}